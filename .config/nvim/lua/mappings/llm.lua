local map_utils = require("utils.map")
local nmap = map_utils.nmap

local M = {}

function M.enable_mappings()
  nmap("<leader>cc", "<CMD>CodeCompanionChat<CR>", { desc = "Code Companion » Chat" })
  nmap("<leader>ci", "<CMD>CodeCompanion<CR>", { desc = "Code Companion » Inline" })
  nmap("<leader>ca", "<CMD>CodeCompanionActions<CR>", { desc = "Code Companion » Actions" })
end

return M
