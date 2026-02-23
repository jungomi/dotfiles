local surround = require("nvim-surround")
local surround_mappings = require("mappings.surround")

local M = {}

function M.setup()
  vim.g.nvim_surround_no_normal_mappings = true

  surround.setup({
    -- Don't move to the opening symbol after the action.
    move_cursor = false,
  })

  surround_mappings.enable_mappings()
end

return M
