local M = {}

-- Create augroups and run all autocmds in them given as a map
-- Multiple events/patterns can be given as a list
-- This is almost identical to using `nvim_create_autocmd` except that the event
-- is not given as a separate argument but in the table as `event = ...`.
-- Also takes care of the groups, which is now much easier with the Lua API.
-- e.g.
-- create_augroups({
--   config_filetype = {
--     {
--       event = "FileType",
--       pattern = "*",
--       command = "setlocal formatoptions-=o",
--       desc = "Disable comment continuation when using `o` or `O`",
--     },
--     {
--       event = "FileType",
--       pattern = { "gitcommit", "markdown", "tex", "text" },
--       command = "setlocal spell",
--       desc = "Enable spell check for relevant files",
--     },
--   },
--   config_buffer = {
--     {
--       event = {"BufRead", "BufNewFile"},
--       pattern = "*.md",
--       command = "setlocal filetype=markdown"
--     },
--     {
--       event = "TextYankPost",
--       pattern = "*",
--       callback = function()
--         vim.hl.on_yank({ higroup = "Yank", timeout = 250 })
--       end,
--       desc = "Highlight yanked text",
--     },
--   }
-- })
function M.create_augroups(groups)
  for group_name, group in pairs(groups) do
    -- Creates the augroup and also clears all autocmds in it if already exists
    local group_id = vim.api.nvim_create_augroup(group_name, { clear = true })
    for _, cmd in ipairs(group) do
      -- Take out the event as it's a separate argument
      local event = cmd.event
      cmd.event = nil
      -- Set the group to the created group, making it part of this group
      cmd.group = group_id
      vim.api.nvim_create_autocmd(event, cmd)
    end
  end
end

return M
