local map_utils = require("utils.map")
local map = map_utils.map
local nmap = map_utils.nmap
local xmap = map_utils.xmap

return {
  -- Commenting out code
  {
    "numToStr/Comment.nvim",
    config = function()
      local Comment_utils = require("Comment.utils")
      local ts_comment_context = require("ts_context_commentstring.internal")

      require("Comment").setup({
        custom_calculation = function(ctx)
          local comment_type = ctx.ctype == Comment_utils.ctype.line and "__default" or "__multiline"
          return ts_comment_context.calculate_commentstring({ key = comment_type })
        end,
      })
    end,
  },

  -- Surround actions
  {
    "kylechui/nvim-surround",
    config = function()
      vim.g.nvim_surround_no_normal_mappings = true
      require("nvim-surround").setup({
        -- Don't move to the opening symbol after the action.
        move_cursor = false,
      })
    end,
    keys = function()
      nmap("sa", "<Plug>(nvim-surround-normal)", { desc = "Surround » Add surrounding pair" })
      nmap("sas", "<Plug>(nvim-surround-normal-cur)", { desc = "Surround » Add surrounding pair aroudn current line" })
      nmap("sd", "<Plug>(nvim-surround-delete)", { desc = "Surround » Delete surrounding pair" })
      nmap("sr", "<Plug>(nvim-surround-change)", { desc = "Surround » Change surrounding pair" })
    end,
  },

  -- Smooth scrolling
  {
    "karb94/neoscroll.nvim",
    opts = {
      -- Disable default mappings
      mappings = {},
      easing_function = "cubic",
    },
    keys = function()
      local neoscroll = require("neoscroll")

      -- By default, as a reference 10 lines should be scrolled in 120ms
      local time = 120
      local time_half = 80
      local reference_lines = 10

      -- Get a normalised duration based on the desired speed.
      -- This uses a reference time to scroll a certain number of lines.
      -- Based on: https://github.com/karb94/neoscroll.nvim/issues/63#issuecomment-1477902635
      local function duration_from_lines(num, custom_time)
        custom_time = custom_time or time
        local win_height = vim.api.nvim_win_get_height(0)
        num = num or win_height
        -- Num can be a percentage of the window
        if num % 1 ~= 0 then
          num = num * win_height
        end
        local lines_ratio = num / win_height
        local win_ratio = win_height / reference_lines
        local factor = win_ratio * lines_ratio
        local log_factor = 1 / math.log(1 / factor + 1, 2)
        return custom_time * log_factor
      end

      map({ "n", "v" }, "<C-u>", function()
        neoscroll.ctrl_u({ duration = duration_from_lines(vim.wo.scroll, time_half) })
      end, {
        desc = "Scroll » Half Page Up",
      })
      map({ "n", "v" }, "<C-d>", function()
        neoscroll.ctrl_d({ duration = duration_from_lines(vim.wo.scroll, time_half) })
      end, {
        desc = "Scroll » Half Page Down",
      })
      map({ "n", "v" }, "<C-b>", function()
        neoscroll.ctrl_b({ duration = duration_from_lines() })
      end, {
        desc = "Scroll » Full Page Up",
      })
      map({ "n", "v" }, "<C-f>", function()
        neoscroll.ctrl_f({ duration = duration_from_lines() })
      end, {
        desc = "Scroll » Full Page Down",
      })

      map({ "n", "v" }, "zt", function()
        neoscroll.zt({ half_win_duration = duration_from_lines(vim.wo.scroll, time_half) })
      end, {
        desc = "Scroll » Current Line to Top",
      })
      map({ "n", "v" }, "zz", function()
        neoscroll.zz({ half_win_duration = duration_from_lines(vim.wo.scroll, time_half) })
      end, {
        desc = "Scroll » Current Line to Centre",
      })
      map({ "n", "v" }, "zb", function()
        neoscroll.zb({ half_win_duration = duration_from_lines(vim.wo.scroll, time_half) })
      end, {
        desc = "Scroll » Current Line to Bottom",
      })
    end,
  },

  -- Highlight changes on undo
  {
    "tzachar/highlight-undo.nvim",
    opts = {},
  },

  -- Interactive search and replace
  {
    "MagicDuck/grug-far.nvim",
    opts = {
      startInInsertMode = false,
      windowCreationCommand = "botright split",
      -- Unlisted buffer and fully deleted when closed.
      -- I don't want it in the buffer/jump history as after a restart
      -- of nvim, it would just give an invalid buffer.
      transient = true,
      resultsSeparatorLineChar = "─",
      resultLocation = {
        -- Leave enough space at the end for the scrollbar
        numberLabelFormat = " [%d]   ",
      },
      keymaps = {
        abort = { n = "<C-c>" },
        close = { n = "gq" },
        historyOpen = { n = "<C-q>" },
        openLocation = { n = "<C-o>" },
        replace = { n = "<C-x>" },
        syncLine = { n = "<C-l>" },
        syncLocations = { n = "<C-s>" },
        toggleShowCommand = { n = "<C-p>" },
      },
    },
    keys = function()
      local grugfar = require("grug-far")
      -- Interactive search and replace
      nmap("<leader>rg", grugfar.open, { desc = "Substitute » GrugFar" })
    end,
  },

  -- Swap two regions of text or replace text selected by motion
  {
    "gbprod/substitute.nvim",
    opts = {
      highlight_substituted_text = {
        enabled = true,
        timer = 250,
      },
      exchange = {
        use_esc_to_cancel = false,
      },
    },
    keys = function()
      local substitute = require("substitute")
      local exchange = require("substitute.exchange")

      -- Substitute
      -- Essentially paste over the operator (does not overwrite yank register)
      nmap("sf", substitute.operator, { desc = "Substitute » Operator" })
      nmap("sff", substitute.line, { desc = "Substitute » Line" })
      xmap("sf", substitute.visual, { desc = "Substitute » Visual" })

      -- Exchange
      nmap("sx", exchange.operator, { desc = "Substitute » Exchange » Operator" })
      nmap("sxx", exchange.line, { desc = "Substitute » Exchange » Line" })
      nmap("sxc", exchange.cancel, { desc = "Substitute » Exchange » Cancel" })
      xmap("sx", exchange.visual, { desc = "Substitute » Exchange » Visual" })
    end,
  },

  -- Automatically adjust indent for pasted code, particularly useful for Python where the formatter cannot
  -- guess that you wanted to have it indented as a part of a nested block.
  {
    "nemanjamalesija/smart-paste.nvim",
    opts = {},
  },
}
