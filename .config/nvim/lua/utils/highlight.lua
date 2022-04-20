local M = {}

-- Reset all highlighting
function M.reset_highlight()
  vim.cmd("highlight clear")
  if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
  end
end

return M
