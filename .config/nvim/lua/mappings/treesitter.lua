local ts_utils = require("utils.treesitter")
local map_utils = require("utils.map")
local nmap = map_utils.nmap
local imap = map_utils.imap

local M = {}

function M.enable_mappings()
  -- Generate DocString of the object under the cursor
  nmap("<leader>sd", "<Cmd>Neogen<CR>", { desc = "Treesitter » Generate DocString" })
  imap("<C-a>", ts_utils.jump_start_of_node, { desc = "Treesitter » Jump to start of Node" })
  imap("<C-e>", ts_utils.jump_end_of_node, { desc = "Treesitter » Jump to end of Node" })
end

return M
