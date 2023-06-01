local scrollview = require("scrollview")
local scrollbar_mappings = require("mappings.scrollbar")

local right_bar = "🮇"

local M = {}

-- Taken from https://gist.github.com/dstein64/b5d9431ebeacae1fb963efc3f2c94cf4
local function setup_gitsigns()
  local group = "gitsigns"

  local add = scrollview.register_sign_spec({
    group = group,
    highlight = "GitSignsAdd",
    symbol = right_bar,
    priority = 80,
  }).name

  local change = scrollview.register_sign_spec({
    group = group,
    highlight = "GitSignsChange",
    symbol = right_bar,
    priority = 80,
  }).name

  local delete = scrollview.register_sign_spec({
    group = group,
    highlight = "GitSignsDelete",
    symbol = right_bar,
    priority = 80,
  }).name

  scrollview.set_sign_group_state(group, true)

  vim.api.nvim_create_autocmd("User", {
    pattern = "ScrollViewRefresh",
    callback = function()
      if not scrollview.is_sign_group_active(group) then
        return
      end
      local success, gitsigns = pcall(require, "gitsigns")
      if not success then
        return
      end
      for _, winid in ipairs(scrollview.get_sign_eligible_windows()) do
        local bufnr = vim.api.nvim_win_get_buf(winid)
        local hunks = gitsigns.get_hunks(bufnr) or {}
        local lines_add = {}
        local lines_change = {}
        local lines_delete = {}
        for _, hunk in ipairs(hunks) do
          if hunk.type == "add" then
            -- Don't show if the entire column would be covered.
            if hunk.added.count < vim.api.nvim_buf_line_count(bufnr) then
              for line = hunk.added.start, hunk.added.start + hunk.added.count - 1 do
                table.insert(lines_add, line)
              end
            end
          elseif hunk.type == "change" then
            for line = hunk.added.start, hunk.added.start + hunk.added.count - 1 do
              table.insert(lines_change, line)
            end
          elseif hunk.type == "delete" then
            table.insert(lines_delete, hunk.added.start)
          end
        end
        vim.b[bufnr][add] = lines_add
        vim.b[bufnr][change] = lines_change
        vim.b[bufnr][delete] = lines_delete
      end
    end,
  })

  vim.api.nvim_create_autocmd("User", {
    pattern = "GitSignsUpdate",
    callback = function()
      if not scrollview.is_sign_group_active(group) then
        return
      end
      scrollview.refresh()
    end,
  })
end

function M.setup()
  scrollview.setup({
    current_only = true,
    winblend = 0,
    signs_on_startup = { "cursor", "diagnostics", "search" },
    -- Most symbols have a Thin Space (U+2009) in order to keep the icons smaller,
    -- as these icons use 2 code points to display fully, but the Thin Space pervents that.
    diagnostics_error_symbol = " ",
    diagnostics_warn_symbol = " ",
    diagnostics_info_symbol = " ",
    diagnostics_hint_symbol = "󰌵 ",
    cursor_priority = 0,
    cursor_symbol = " ",
    search_symbol = right_bar,
    spell_symbol = " ",
  })

  setup_gitsigns()

  scrollbar_mappings.enable_mappings()
end

return M
