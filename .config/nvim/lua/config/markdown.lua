local markview = require("markview")
local markdown_mappings = require("mappings.markdown")
local theme = require("theme").theme

local M = {}

function M.setup()
  markview.setup({
    -- For some reason markview started ignoring the highlight groups that are statically defined in the theme,
    -- and just overwrites them at run time.
    -- That's annoying, but it is an easy fix, just passing them to this option as well.
    -- Thankfully I defined them in a neat table, so that it can literally be reused as is.
    highlight_groups = theme.markview,
    preview = {
      hybrid_modes = { "n", "no" },
    },
    code_blocks = {
      pad_amount = 1,
    },
    inline_codes = {
      corner_left = "",
      corner_right = "",
    },
    markdown = {
      list_items = {
        marker_minus = { add_padding = false, text = "•" },
        marker_plus = { add_padding = false, text = "◆" },
        marker_star = { add_padding = false, text = "★" },
        marker_dot = { add_padding = false },
        marker_parenthesis = { add_padding = false },
      },
    },
  })
  markdown_mappings.enable_mappings()
end

return M
