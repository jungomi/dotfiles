local M = {}

local unpack = table.unpack or unpack

function M.get_pos(node, opts)
  opts = opts or {}
  if opts.backward then
    return node:start()
  else
    return node:end_()
  end
end

-- Gets the parent that is not starting/ending at the same position as the current node.
-- This means that when in a nested node, the cursor is at the very beginning, the parent
-- will be outside of all the nestings (i.e. where a node has extra characters before it)
function M.get_parent_outside(node, opts)
  local row, col = M.get_pos(node, opts)
  local parent = node:parent()
  while parent do
    local row_p, col_p = M.get_pos(parent, opts)
    node = parent
    parent = parent:parent()
    if row_p ~= row or col_p ~= col then
      break
    end
  end
  return node
end

function M.get_node_outside(node, opts)
  opts = opts or {}
  local row_cursor, col_cursor = unpack(vim.api.nvim_win_get_cursor(0))
  -- The cursor row is 1 indexed, but the treesitter nodes are zero indexed.
  row_cursor = row_cursor - 1
  local row, col = M.get_pos(node, opts)
  if row == row_cursor and col == col_cursor then
    return M.get_parent_outside(node, opts)
  else
    return node
  end
end

function M.jump_node(opts)
  opts = opts or {}
  local node = vim.treesitter.get_node()
  if node == nil then
    return
  end
  node = M.get_node_outside(node, opts)

  local row, col = M.get_pos(node, opts)
  pcall(vim.api.nvim_win_set_cursor, 0, { row + 1, col })
end

function M.jump_start_of_node()
  M.jump_node({ backward = true })
end

function M.jump_end_of_node()
  M.jump_node()
end

return M
