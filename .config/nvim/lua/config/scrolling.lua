local neoscroll = require("neoscroll")
local scrolling_mappings = require("mappings.scrolling")

local M = {}

function M.setup()
  neoscroll.setup({
    -- Disable default mappings
    mappings = {},
    easing_function = "cubic",
  })

  scrolling_mappings.enable_mappings()
end

return M
