local markview = require("markview")
local markdown_mappings = require("mappings.markdown")

local M = {}

function M.setup()
  markview.setup({
    hybrid_modes = { "n", "no" },
    code_blocks = {
      pad_amount = 1,
    },
    inline_codes = {
      corner_left = "",
      corner_right = "",
    },
    list_items = {
      marker_minus = { add_padding = false, text = "•" },
      marker_plus = { add_padding = false, text = "◆" },
      marker_star = { add_padding = false, text = "★" },
      marker_dot = { add_padding = false },
      marker_parenthesis = { add_padding = false },
    },
  })
  markdown_mappings.enable_mappings()
end

return M
