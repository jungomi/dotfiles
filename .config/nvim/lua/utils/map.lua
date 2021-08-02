local map_key = vim.api.nvim_set_keymap

local M = {}

-- Map keys with noremap by default
function M.map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  map_key(mode, lhs, rhs, options)
end

-- Create aliases for each mode (e.g. nmap)
-- See :help map-table
local modes = {"n", "i", "c", "v", "x", "s", "o", "t", "l"}
for _, mode in ipairs(modes) do
  M[mode .. "map"] = function(...) M.map(mode, ...) end
end

-- Terminal code escaping for mappings in expressions
function M.t(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

return M
