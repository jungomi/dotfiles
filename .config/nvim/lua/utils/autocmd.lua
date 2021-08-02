local M = {}

local function combine_if_multiple(input, sep)
  local separator = sep or ","
  if type(input) == "table" then
    return table.concat(input, separator)
  else
    return input
  end
end

-- Create augroups and run all autocmds in them given as a map
-- Multiple events/patterns can be given as a list
-- e.g.
-- create_augroups {
--   filetype_settings = {
--     {"FileType", "*", "setlocal colorcolumn=80"},
--     {"FileType", {"gitcommit", "markdown", "tex"}, "setlocal spell"},
--   },
--   buffer_modification = {
--     {{"BufRead", "BufNewFile"}, "*.md", "setlocal filetype=markdown"},
--   }
-- }
function M.create_augroups(groups)
  for group_name, group in pairs(groups) do
    M.augroup(group_name)
    M.remove_autocmd() -- Clears all autocmds in this augroup
    for _, cmd in ipairs(group) do
      M.autocmd(unpack(cmd))
    end
    M.end_augroup()
  end
end

function M.autocmd(event, pattern, cmd, opt)
  local options = opt or {}
  -- autocmd[!] [group] event pattern [++once] [++nested] cmd
  local cmd_parts = { "autocmd" }
  if options.remove then
    cmd_parts = { "autocmd!" }
  end
  if options.group then
    table.insert(cmd_parts, options.group)
  end
  -- Event and pattern can be a list of events
  table.insert(cmd_parts, combine_if_multiple(event))
  table.insert(cmd_parts, combine_if_multiple(pattern))
  if options.once then
    table.insert(cmd_parts, "++once")
  end
  if options.nested then
    table.insert(cmd_parts, "++nested")
  end
  table.insert(cmd_parts, cmd)
  vim.cmd(table.concat(cmd_parts, " "))
end

function M.remove_autocmd(event, pattern, cmd, opt)
  local options = opt or {}
  options.remove = true
  M.autocmd(event, pattern, cmd, options)
end

function M.augroup(name, opt)
  local options = opt or {}
  -- augroup[!] name
  local cmd_parts = { "augroup" }
  if options.remove then
    cmd_parts = { "augroup!" }
  end
  table.insert(cmd_parts, name)
  vim.cmd(table.concat(cmd_parts, " "))
end

function M.clear_augroup(name)
  M.augroup(name)
  M.remove_autocmd()
  M.end_augroup()
end

-- Removes the augroup but clears it first to avoid dangling autocmd
function M.remove_augroup(name, opt)
  local options = opt or {}
  options.remove = true
  M.clear_augroup(name)
  M.augroup(name, options)
end

function M.end_augroup()
  M.augroup("END")
end

return M
