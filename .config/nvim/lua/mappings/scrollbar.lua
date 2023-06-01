local map_utils = require("utils.map")
local nmap = map_utils.nmap

local M = {}

function M.enable_mappings()
  -- Navigation to signs
  nmap("]v", "<Cmd>ScrollViewNext<CR>", { desc = "Scrollbar » Jump to next sign" })
  nmap("[v", "<Cmd>ScrollViewPrev<CR>", { desc = "Scrollbar » Jump to previous sign" })
  nmap("[V", "<Cmd>ScrollViewFirst<CR>", { desc = "Scrollbar » Jump to first sign" })
  nmap("]V", "<Cmd>ScrollViewLast<CR>", { desc = "Scrollbar » Jump to last sign" })
  nmap("<leader>sv", "<Cmd>ScrollViewToggle spell<CR>", { desc = "Scrollbar » Toggle Spell Signs" })
end

return M
