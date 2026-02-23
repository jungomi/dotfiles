local map_utils = require("utils.map")
local nmap = map_utils.nmap

local M = {}

function M.enable_mappings()
  nmap("sa", "<Plug>(nvim-surround-normal)", { desc = "Surround » Add surrounding pair" })
  nmap("sas", "<Plug>(nvim-surround-normal-cur)", { desc = "Surround » Add surrounding pair aroudn current line" })
  nmap("sd", "<Plug>(nvim-surround-delete)", { desc = "Surround » Delete surrounding pair" })
  nmap("sr", "<Plug>(nvim-surround-change)", { desc = "Surround » Change surrounding pair" })
end

return M
