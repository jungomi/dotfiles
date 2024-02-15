local map_utils = require("utils.map")
local nmap = map_utils.nmap

local M = {}

function M.enable_mappings()
  nmap("<leader>mv", "<CMD>Oil --float<CR>", { desc = "Oil » Floating Window" })
end

return M
