local map_utils = require("utils.map")
local nmap = map_utils.nmap

local M = {}

function M.enable_mappings()
  nmap("<leader>ms", "<Cmd>Markview splitToggle<CR>", { desc = "Markview » Split Toggle" })
  nmap("<leader>mh", "<Cmd>Markview hybridToggle<CR>", { desc = "Markview » Hybrid Mode Toggle" })
end

return M
