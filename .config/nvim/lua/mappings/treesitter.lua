local map_utils = require("utils.map")
local nmap = map_utils.nmap

local M = {}

function M.enable_mappings()
  -- Generate DocString of the object under the cursor
  nmap("<leader>sd", "<Cmd>Neogen<CR>", { desc = "Treesitter » Generate DocString" })
end

return M
