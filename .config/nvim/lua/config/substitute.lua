local substitute = require("substitute")
local substitude_mappings = require("mappings.substitute")

local M = {}

function M.setup()
  substitute.setup({
    highlight_substituted_text = {
      enabled = true,
      timer = 250,
    },
    exchange = {
      use_esc_to_cancel = false,
    },
  })
  substitude_mappings.enable_mappings()
end

return M
