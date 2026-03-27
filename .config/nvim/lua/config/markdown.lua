local markview = require("markview")
local markdown_mappings = require("mappings.markdown")
local theme = require("theme").theme
local autocmd_utils = require("utils.autocmd")

local M = {}

function M.fix_theme()
  for group, colour in pairs(theme.markview) do
    vim.api.nvim_set_hl(0, group, colour)
  end
end

function M.setup()
  markview.setup({
    -- Thankfully I defined them in a neat table, so that it can literally be reused as is.
    highlight_groups = theme.markview,
    preview = {
      hybrid_modes = { "n", "no" },
      filetypes = { "markdown", "codecompanion" },
      ignore_buftypes = {},
    },
    markdown = {
      code_blocks = {
        pad_amount = 1,
        diff = {
          block_hl = function(_, line)
            if line:match("^%+") and not line:match("^%+%+%+") then
              return "MarkviewDiffAdd"
            elseif line:match("^%-") and not line:match("^%-%-%-") then
              return "MarkviewDiffDelete"
            else
              return "MarkviewCode"
            end
          end,
          pad_hl = "MarkviewCode",
        },
      },
      list_items = {
        marker_minus = { add_padding = false, text = "•" },
        marker_plus = { add_padding = false, text = "◆" },
        marker_star = { add_padding = false, text = "★" },
        marker_dot = { add_padding = false },
        marker_parenthesis = { add_padding = false },
      },
    },
    markdown_inline = {
      inline_codes = {
        corner_left = "",
        corner_right = "",
      },
    },
  })
  markdown_mappings.enable_mappings()

  -- For some reason markview started ignoring the highlight groups that are statically defined in the theme,
  -- and just overwrites them at run time.
  -- That's annoying, but it is an easy fix with the autocommand.
  autocmd_utils.create_augroups({
    config_markview = {
      {
        event = "User",
        pattern = "MarkviewEnable",
        callback = M.fix_theme,
        desc = "Markview fix theme for overwritten heading highlights",
      },
    },
  })
end

return M
