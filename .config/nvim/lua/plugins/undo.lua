local borders = require("borders")
local icons = require("icons")
local nmap = require("utils.map").nmap

return {
  -- Highlight changes on undo
  {
    "tzachar/highlight-undo.nvim",
    opts = {},
  },

  -- Undo tree visualizer and navigator
  {
    "XXiaoA/atone.nvim",
    config = function()
      local utils = require("atone.utils")

      -- Track the saved state sequence number whenever a buffer is read or written,
      -- and refresh Atone automatically if the tree is currently open.
      vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
        group = vim.api.nvim_create_augroup("AtoneSavedState", { clear = true }),
        callback = function(ev)
          vim.b[ev.buf].atone_saved_seq = vim.fn.undotree(ev.buf).seq_cur
          local core = package.loaded["atone.core"]
          if core and core._show and ev.buf == core.attach_buf then
            core.refresh()
          end
        end,
      })

      local get_saved_map = utils.cache(function(buf, seq_last, save_last, saved_seq)
        local ut = vim.fn.undotree(buf)
        local saved = {}
        local latest_save_seq = nil

        local function walk(entries)
          for _, e in ipairs(entries) do
            if e.save then
              saved[e.seq] = "save"
              if e.save == ut.save_last then
                latest_save_seq = e.seq
              end
            end
            if e.alt then
              walk(e.alt)
            end
          end
        end

        if ut.entries then
          walk(ut.entries)
        end

        -- Determine the active / most recent saved state
        local active_save_seq = saved_seq
        if not active_save_seq or active_save_seq == 0 then
          active_save_seq = latest_save_seq
        end

        if active_save_seq and active_save_seq > 0 then
          saved[active_save_seq] = "latest_save"
        end

        return saved
      end)

      require("atone").setup({
        keymaps = {
          tree = {
            quit = { "<C-C>", "gq" },
          },
          help = {
            quit_help = { "<Esc>", "<C-c>", "gq" },
          },
        },
        layout = {
          width = 0.3,
        },
        ui = {
          border = borders.default,
          -- Custom rendering
          --        [92]   1 min ago (current)
          --         [91]    1 hr ago
          node_label = {
            custom = true,
            ---@param ctx AtoneNodeLabelContext
            formatter = function(ctx)
              local chunks = {}
              local buf = require("atone.tree").attach_buf
              if buf == nil then
                return chunks
              end
              local undotree = vim.fn.undotree(buf)
              local saved_seq = vim.b[buf].atone_saved_seq
              if not vim.bo[buf].modified then
                saved_seq = undotree.seq_cur
                vim.b[buf].atone_saved_seq = saved_seq
              end

              local saved = get_saved_map(buf, undotree.seq_last, undotree.save_last, saved_seq)
              local state = saved[ctx.seq]

              local max_seq = math.max(undotree.seq_last or 0, 99)
              local max_bracket_len = #string.format("[%d]", max_seq)
              local raw_seq = string.format("[%d]", ctx.seq)
              local pad = string.rep(" ", max_bracket_len - #raw_seq)

              -- Highlight and mark the selected / current state
              if ctx.is_current then
                table.insert(chunks, { icons.triangle.normal .. " ", "DiagnosticOk" })
                table.insert(chunks, { raw_seq .. pad, "Title" })
              else
                table.insert(chunks, { "  ", "Normal" })
                table.insert(chunks, { raw_seq .. pad, "Comment" })
              end
              -- Saved state indicator:
              -- "latest_save" is highlighted in DiagnosticOk (green), historical "save" in DiagnosticWarn (amber).
              if state then
                local hl = (state == "latest_save") and "DiagnosticOk" or "DiagnosticWarn"
                table.insert(chunks, { " " .. icons.lsp_kind.Field .. "  ", hl })
              else
                table.insert(chunks, { "    ", "Normal" })
              end
              -- Relative timestamp
              table.insert(chunks, { ctx.h_time, ctx.is_current and "Normal" or "Comment" })
              -- Current state badge
              if ctx.is_current then
                table.insert(chunks, { " (current)", "DiagnosticOk" })
              end
              -- Bookmarks & sticky ref indicators
              if ctx.bookmark and ctx.bookmark ~= "" then
                table.insert(chunks, { " " .. ctx.bookmark, "DiagnosticInfo" })
              end
              if ctx.is_sticky_ref then
                table.insert(chunks, { " [=]", "DiagnosticHint" })
              end

              return chunks
            end,
          },
        },
      })
    end,
    keys = function()
      nmap("<leader>u", "<Cmd>Atone toggle<CR>", { desc = "Undotree » Toggle" })
    end,
  },
}
