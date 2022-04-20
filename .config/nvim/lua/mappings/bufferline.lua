local map_utils = require("utils.map")
local nmap = map_utils.nmap

local M = {}

function M.enable_mappings()
  -- Cycle through buffers in their visual order
  nmap("]b", "<Cmd>BufferLineCycleNext<CR>", { desc = "Buffer » Previous" })
  nmap("[b", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Buffer » Next" })
end

return M
