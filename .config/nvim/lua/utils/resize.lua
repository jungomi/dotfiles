local M = {
  pos = {
    first = 1,
    last = -1,
    other = 0,
  },
}

function M.horizontal_position()
  local win = vim.fn.winnr()
  if win == vim.fn.winnr("h") then
    return M.pos.first
  elseif win == vim.fn.winnr("l") then
    return M.pos.last
  else
    return M.pos.other
  end
end

function M.vertical_position()
  local win = vim.fn.winnr()
  if win == vim.fn.winnr("k") then
    return M.pos.first
  elseif win == vim.fn.winnr("j") then
    return M.pos.last
  else
    return M.pos.other
  end
end

function M.current_position()
  return { M.horizontal_position(), M.vertical_position() }
end

function M.up(num)
  num = num or 2
  local pos = M.vertical_position()
  if pos == M.pos.last then
    vim.cmd(string.format("resize +%d", num))
  else
    vim.cmd(string.format("resize -%d", num))
  end
end

function M.down(num)
  num = num or 2
  local pos = M.vertical_position()
  if pos == M.pos.last then
    vim.cmd(string.format("resize -%d", num))
  else
    vim.cmd(string.format("resize +%d", num))
  end
end

function M.left(num)
  num = num or 5
  local pos = M.horizontal_position()
  if pos == M.pos.last then
    vim.cmd(string.format("vertical resize +%d", num))
  else
    vim.cmd(string.format("vertical resize -%d", num))
  end
end

function M.right(num)
  num = num or 5
  local pos = M.horizontal_position()
  if pos == M.pos.last then
    vim.cmd(string.format("vertical resize -%d", num))
  else
    vim.cmd(string.format("vertical resize +%d", num))
  end
end

return M
