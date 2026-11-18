local icons = require("icons")
local autocmd_utils = require("utils.autocmd")
local nmap = require("utils.map").nmap

local neogit_spec = {
  "NeogitOrg/neogit",
  config = function()
    local neogit_status = require("neogit.buffers.status")
    local CommitView = require("neogit.buffers.commit_view")

    -- This assumes that it's only called within a NeogitStatus buffer.
    -- No checks are done here, since this will be used in an autocmd instead.
    local function neogit_status_toggle_file()
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

    -- Refresh the status buffer, because apparently Neogit just never refreshes it on its own, unless
    -- a specific action has been performed (i.e. only after some of the mappings ared used in the buffer)
    local function neogit_status_refresh()
      local instance = neogit_status.instance()
      if instance ~= nil then
        instance:refresh()
      end
    end

    require("neogit").setup({
      kind = "split",
      graph_style = "unicode",
      use_per_project_settings = false,
      disable_insert_on_commit = true,
      disable_hint = true,
      -- Don't show the spinner, it is buggy and also unnecessarily distracting.
      process_spinner = false,
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
          ["$"] = false,
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
          ["<M-$>"] = "CommandHistory",
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

    autocmd_utils.create_augroups({
      config_neogit = {
        {
          event = "FocusGained",
          pattern = "*",
          callback = neogit_status_refresh,
          desc = "Neogit refresh status buffer when nvim gains focus",
        },
        {
          event = "WinEnter",
          pattern = "NeogitStatus",
          callback = neogit_status_refresh,
          desc = "Neogit refresh status buffer when entering the status window",
        },
        {
          event = "FileType",
          pattern = "NeogitStatus",
          callback = function()
            vim.keymap.set("n", "=", neogit_status_toggle_file, { buffer = true })
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
            local commit_id =
              vim.fn.matchlist(vim.api.nvim_get_current_line(), [[^\%(\w\+\>\)\=\s*\(\x\{4,40\}\>\)]])[2]
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
  end,
  keys = function()
    -- Open Git status for git repo of current file.
    nmap("<leader>gs", function()
      local git_dir = vim.fs.root(0, ".git")
      if git_dir then
        -- The directory name needs to be the full path without the trailing slash (hence ":p:h")
        vim.cmd(string.format("Neogit cwd=%s", vim.fn.fnamemodify(git_dir, ":p:h")))
      else
        vim.cmd("Neogit")
      end
    end, {
      desc = "Git » Status",
    })
  end,
}

local gitsigns_spec = {
  "lewis6991/gitsigns.nvim",
  opts = {
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
  },
  keys = function()
    -- Navigation to git changes
    nmap("]g", "<Cmd>Gitsigns next_hunk<CR>", { desc = "Git » Jump to next hunk" })
    nmap("[g", "<Cmd>Gitsigns prev_hunk<CR>", { desc = "Git » Jump to previous hunk" })
    nmap("<leader>gb", "<Cmd>Gitsigns blame_line<CR>", { desc = "Git » Blame line" })
    nmap("<leader>gw", "<Cmd>Gitsigns toggle_word_diff<CR>", { desc = "Git » Toggle word diff" })
    nmap("<leader>gp", "<Cmd>Gitsigns preview_hunk<CR>", { desc = "Git » Preview hunk diff" })
  end,
}

local codediff_spec = {
  -- VSCode style diffs (char wise)
  -- Also comes with a merge tool similar to VSCode
  "esmuellert/codediff.nvim",
  opts = {
    highlights = {
      line_delete = "MarkviewDiffDelete",
    },
    explorer = {
      view_mode = "tree",
      indent_markers = false,
      icons = {
        folder_closed = " ",
        folder_open = " ",
      },
    },
    diff = {
      -- Need ours to be on the left, don't know why VSCode flipped it.
      -- This currently causes issues with the keymaps, so will keep the default for now.
      conflict_ours_position = "left",
      -- Height percent (not num lines) if the result is at at the bottom
      conflict_result_height = 50,
    },
    keymaps = {
      view = {
        quit = "gq",
      },
      conflict = {
        -- All these keymaps are flipped, as it does not choose the buffer when having "ours" on the left.
        -- e.g. `accept_incoming` is really `accept_left`.
        accept_incoming = "<leader>co",
        accept_current = "<leader>ct",
        accept_all_incoming = "<leader>cO",
        accept_all_current = "<leader>cT",
        diffget_incoming = "<leader>co",
        diffget_current = "<leader>ct",
      },
    },
  },
  keys = function()
    -- Diffview without the untracked files (-uno)
    nmap("<leader>gd", "<Cmd>CodeDiff<CR>", { desc = "Git » Diff" })
  end,
}

return {
  neogit_spec,
  gitsigns_spec,
  codediff_spec,
  "nvim-lua/plenary.nvim",
}
