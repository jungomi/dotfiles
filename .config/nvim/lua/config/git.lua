local neogit = require("neogit")
local neogit_status = require("neogit.buffers.status")
local CommitView = require("neogit.buffers.commit_view")
local diffview = require("diffview")
local diffview_actions = require("diffview.actions")
local git_signs = require("gitsigns")
local icons = require("icons")
local git_mappings = require("mappings.git")
local autocmd_utils = require("utils.autocmd")

local M = {}

-- This assumes that it's only called within a NeogitStatus buffer.
-- No checks are done here, since this will be used in an autocmd instead.
function M.neogit_status_toggle_file()
  local instance = neogit_status.instance()
  if instance == nil then
    error(string.format("Neogit: No instance for %s", vim.uv.cwd()))
  end
  local current_ui = instance.buffer.ui

  local cursor = vim.api.nvim_win_get_cursor(0)
  local component = current_ui:_find_component_by_index(cursor[1], function(node)
    return node.options.item
  end)
  if component == nil then
    return
  end

  if component.options.folded then
    component:open_all_folds(current_ui, 2)
  else
    component:close_all_folds(current_ui)
  end

  current_ui:update()

  -- Move the cursor to the beginning of the item.
  -- Otherwise staging on the collapsed item will only stage the hunk.
  instance.buffer:move_cursor(component:row_range_abs())
  vim.cmd("normal! zt")
end

function M.setup()
  git_signs.setup({
    signs = {
      add = { text = " ┃" },
      change = { text = " ┃" },
      delete = { text = " ⎯" },
      topdelete = { text = " ‾" },
      changedelete = { text = " ≃" },
    },
    current_line_blame_opts = {
      delay = 300,
    },
  })

  diffview.setup({
    keymaps = {
      view = {
        { "n", "gq", "<Cmd>DiffviewClose<CR>", { desc = "Close the Diff View" } },
      },
      file_panel = {
        { "n", "gq", "<Cmd>DiffviewClose<CR>", { desc = "Close the Diff View" } },
        { "n", "l", diffview_actions.open_fold, { desc = "Expand fold" } },
        { "n", "=", diffview_actions.toggle_fold, { desc = "Toggle fold" } },
      },
      file_history_panel = {
        { "n", "gq", "<Cmd>DiffviewClose<CR>", { desc = "Close the Diff View" } },
      },
    },
  })

  neogit.setup({
    kind = "split",
    graph_style = "unicode",
    use_per_project_settings = false,
    disable_insert_on_commit = true,
    disable_hint = true,
    mappings = {
      popup = {
        -- Don't touch the navigation mappings ...
        ["l"] = false,
        ["b"] = false,
        ["B"] = false,
        ["w"] = false,
        ["W"] = false,
        ["<C-b>"] = "BranchPopup",
        ["gb"] = "BisectPopup",
        ["gw"] = "WorktreePopup",
        ["gl"] = "LogPopup",
      },
      status = {
        ["q"] = false,
        ["gq"] = "Close",
        ["{"] = false,
        ["}"] = false,
        ["[c"] = "GoToPreviousHunkHeader",
        ["]c"] = "GoToNextHunkHeader",
        -- Some garbage mappings, because apparently all commands need to be present,
        -- otherwise it crashes, because Neogit is terribly designed for customisability.
        ["<M-U>"] = "OpenOrScrollUp",
        ["<M-D>"] = "OpenOrScrollDown",
      },
      commit_editor = {
        ["q"] = false,
        ["gq"] = "Close",
      },
      rebase_editor = {
        ["q"] = false,
        ["gq"] = "Close",
      },
    },
    signs = {
      -- { CLOSED, OPENED }
      hunk = { "", "" },
      item = { "", "" },
      section = { icons.fold.collapsed, icons.fold.expanded },
    },
    status = {
      show_head_commit_hash = true,
      HEAD_padding = 8,
      mode_padding = 1,
      mode_text = {
        M = "M",
        N = "N",
        A = "A",
        D = "D",
        C = "C",
        U = "U",
        R = "R",
        DD = "?",
        AU = "?",
        UD = "?",
        UA = "?",
        DU = "?",
        AA = "?",
        UU = "?",
        ["?"] = "?",
      },
    },
    sections = {
      stashes = {
        folded = false,
      },
      recent = {
        folded = false,
      },
      rebase = {
        folded = false,
      },
    },
    integrations = {
      telescope = false,
    },
  })

  git_mappings.enable_mappings()

  autocmd_utils.create_augroups({
    config_neogit = {
      {
        event = "FileType",
        pattern = "NeogitStatus",
        callback = function()
          vim.keymap.set("n", "=", M.neogit_status_toggle_file, { buffer = true })
        end,
        desc = "Neogit status mapping to toggle file fold",
      },
      {
        event = "FileType",
        -- Neogit now uses the native gitcommit but overwrites some settings...
        pattern = "gitcommit",
        callback = function(args)
          -- HACK: Delay setting the filetype / treesitter, because Neogit first creates the buffer,
          -- then later enables it, which comes after the event has fired (overwriting anything).
          vim.defer_fn(function()
            vim.treesitter.stop()
            -- Enable line numbers for this, because Neogit always disables them after creating the buffer.
            vim.api.nvim_set_option_value("number", true, { win = args.win })
          end, 100)
        end,
        desc = "Neogit disable treesitter highlights and use regular gitcommit buffer",
      },
      {
        event = "CursorMoved",
        pattern = "git-rebase-todo",
        callback = function()
          -- This uses vim's regex because Lua doesn't support counts (i.e. {4, 40}).
          -- The commit is in capture group 1, which is the second element in the list
          local commit_id = vim.fn.matchlist(vim.api.nvim_get_current_line(), [[^\%(\w\+\>\)\=\s*\(\x\{4,40\}\>\)]])[2]
          if commit_id == nil then
            return
          end
          if CommitView.is_open() then
            -- Only change the buffer if it is not the same ID as this also reset scrolls to the top
            if CommitView.instance.commit_info.commit_arg ~= commit_id then
              CommitView.instance:update(commit_id)
              CommitView.instance.buffer:win_exec("normal! gg")
            end
          else
            local curr_win = vim.api.nvim_get_current_win()
            CommitView.new(commit_id):open("split")
            vim.api.nvim_set_current_win(curr_win)
          end
        end,
        desc = "Neogit show diff for commit under cursor during interactive rebase",
      },
      {
        -- That seems to be the event that is fired when closing the interactive rebase in Neogit.
        event = "BufWipeout",
        pattern = "git-rebase-todo",
        callback = function()
          if CommitView.is_open() then
            CommitView.instance:close()
          end
        end,
        desc = "Neogit close the diff when closing the interactive rebase",
      },
    },
  })
end

return M
