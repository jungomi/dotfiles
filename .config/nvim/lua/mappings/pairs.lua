local autopairs = require("nvim-autopairs")
local map_utils = require("utils.map")
local imap = map_utils.imap

local M = {}

function M.enable_mappings()
  -- CR with autopairs
  -- replace_keycodes needs to be set to false, because autopairs escape it themselves and returns it.
  imap("<C-f>", function()
    return autopairs.autopairs_cr()
  end, { expr = true, replace_keycodes = false, desc = "Pairs » CR with autopairs" })
end

return M
