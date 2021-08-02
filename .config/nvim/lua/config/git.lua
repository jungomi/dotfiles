local git_signs = require("gitsigns")
local git_mappings = require("mappings.git")

local M = {}

function M.setup()
  git_signs.setup({
    signs = {
      add = { text = " ┃" },
      change = { text = " ┃" },
      delete = { text = " ⎯" },
      topdelete = { text = " ‾" },
      changedelete = { text = " ≃" },
    },
    current_line_blame_delay = 300,
  })
  git_mappings.enable_mappings()
end

return M
