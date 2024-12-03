local borders = require("borders")

return {
  -- Commenting out code
  {
    "numToStr/Comment.nvim",
    config = function()
      require("config.comment").setup()
    end,
  },
  {
    "kylechui/nvim-surround",
    config = function()
      require("nvim-surround").setup({
        keymaps = {
          normal = "sa",
          normal_cur = "sas",
          delete = "sd",
          change = "sr",
          -- Disable some unused ones (they get in the way of mostly operator pending mappings)
          -- Also mostly line based (i.e. inserting the brackets around the line, instead of around the selection)
          normal_line = false,
          normal_cur_line = false,
          -- BUG: cannot set this to false, otherwise the change (sr) mapping doesn't work,
          -- so just have it on srs which I'll probbably never use, but at least it's not interferring.
          change_line = "srs",
        },
        -- Don't move to the opening symbol after the action.
        move_cursor = false,
      })
    end,
  },
  -- Automatically close brackets
  -- I mostly want it for blocks when pressing <CR>.
  {
    "windwp/nvim-autopairs",
    config = function()
      require("config.pairs").setup()
    end,
  },
  -- Smooth scrolling
  {
    "karb94/neoscroll.nvim",
    config = function()
      require("config.scrolling").setup()
    end,
  },
  -- Custom modes (continuous actions) e.g. resizing mode
  {
    "nvimtools/hydra.nvim",
    config = function()
      require("config.hydra").setup()
    end,
  },
  {
    "tzachar/highlight-undo.nvim",
    opts = {},
  },
  {
    "stevearc/oil.nvim",
    config = function()
      require("config.oil").setup()
    end,
    dependencies = { "nvim-tree/nvim-web-devicons" },
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
  },
  -- Swap two regions of text or replace text selected by motion
  {
    "gbprod/substitute.nvim",
    config = function()
      require("config.substitute").setup()
    end,
  },
  {
    "stevearc/overseer.nvim",
    config = function()
      require("config.overseer").setup()
    end,
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      quickfile = { enabled = false },
      notifier = {
        enabled = true,
        timeout = 3000,
        margin = {
          top = 1,
        },
        style = function(buf, notif, ctx)
          -- This was copied from "snacks.notifier.styles.compact", but since that is not exposed, there is no other way
          -- to just extend it.
          -- It is specifically to modify a render issue with the stautscolumn, for which no configuration option seems
          -- to do the job.
          local title = vim.trim(notif.icon .. " " .. (notif.title or ""))
          if title ~= "" then
            ctx.opts.title = { { " " .. title .. " ", ctx.hl.title } }
            ctx.opts.title_pos = "center"
          end
          vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(notif.msg, "\n"))
          -- Additions:
          -- Set the statuscolumn to the same colour as the background.
          ctx.opts.wo.winhighlight = ctx.opts.wo.winhighlight .. ",LineNr:Normal"
        end,
      },
      statuscolumn = { enabled = false },
      words = { enabled = false },
      styles = {
        notification = {
          zindex = 50,
          wo = {
            winblend = 0,
            wrap = true,
          },
        },
        ["notification.history"] = {
          width = 0.8,
          border = borders.default,
          wo = {
            winhighlight = "Normal:NormalFloat",
            number = false,
            signcolumn = "no",
          },
        },
      },
    },
  },
}
