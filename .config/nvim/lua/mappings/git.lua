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

  -- Diffview without the untracked files (-uno)
  nmap("<leader>gd", "<Cmd>CodeDiff<CR>", { desc = "Git » Diff" })
  -- Open Git status for git repo of current file.
  nmap("<leader>gs", function()
    local git_dir = vim.fs.root(0, ".git")
    if git_dir then
      -- The directory name needs to be the full path without the trailing slash (hence ":p:h")
      vim.cmd(string.format("Neogit cwd=%s", vim.fn.fnamemodify(git_dir, ":p:h")))
    else
      vim.cmd("Neogit")
    end
  end, {
    desc = "Git » Status",
  })
end

return M
