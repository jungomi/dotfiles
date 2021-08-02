local kommentary = require("kommentary.config")
local comment_mappings = require("mappings.comment")

local M = {}

function M.setup()
  vim.g.kommentary_create_default_mappings = false
  kommentary.configure_language("default", {
    -- Always use single line comments even when commenting multiple lines
    prefer_single_line_comments = true,
  })
  comment_mappings.enable_mappings()
end

return M
