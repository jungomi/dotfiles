local map_utils = require("utils.map")
local nmap = map_utils.nmap

local M = {}

function M.enable_mappings()
  -- Navigation to git changes
  nmap("]g", "<Cmd>Gitsigns next_hunk<CR>", { desc = "Git » Jump to next hunk" })
  nmap("[g", "<Cmd>Gitsigns prev_hunk<CR>", { desc = "Git » Jump to previous hunk" })
  nmap("<leader>gb", "<Cmd>Gitsigns blame_line<CR>", { desc = "Git » Blame line" })
  nmap("<leader>gw", "<Cmd>Gitsigns toggle_word_diff<CR>", { desc = "Git » Toggle word diff" })
  nmap("<leader>gp", "<Cmd>Gitsigns preview_hunk<CR>", { desc = "Git » Preview hunk diff" })
end

return M
