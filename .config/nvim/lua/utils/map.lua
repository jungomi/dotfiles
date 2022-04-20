local M = {}
M.map = vim.keymap.set

-- Create aliases for each mode (e.g. nmap)
-- See :help map-table
local modes = { "n", "i", "c", "v", "x", "s", "o", "t", "l" }
for _, mode in ipairs(modes) do
  M[mode .. "map"] = function(...)
    M.map(mode, ...)
  end
end

-- Terminal code escaping for mappings in expressions
function M.t(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

return M
