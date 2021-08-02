local map_utils = require("utils.map")
local nmap = map_utils.nmap

local M = {}

function M.enable_mappings()
  -- Navigation to git changes
  nmap("]g", "<Cmd>Gitsigns next_hunk<CR>")
  nmap("[g", "<Cmd>Gitsigns prev_hunk<CR>")
  nmap("<leader>gb", "<Cmd>Gitsigns blame_line<CR>")
  nmap("<leader>gw", "<Cmd>Gitsigns toggle_word_diff<CR>")
  nmap("<leader>gp", "<Cmd>Gitsigns preview_hunk<CR>")
end

return M
