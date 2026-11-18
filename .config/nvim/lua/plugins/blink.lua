local borders = require("borders")
local icons = require("icons")
local imap = require("utils.map").imap
local smap = require("utils.map").smap

local M = {
  "saghen/blink.cmp",
}

-- Source names to be shown in the completion menu
local source_names = {
  path = "Path",
  buffer = "Buff",
  calc = "Calc",
  nvim_lsp = "LSP",
  lazydev = "Lua",
  luasnip = "Snip",
  snippets = "Snip",
  tmux = "Tmux",
}

function M.config()
  local blink_cmp = require("blink.cmp")

  -- Completion
  -- Make sure the dependencies are built.
  if type(blink_cmp.build) == "function" then
    blink_cmp.build():pwait()
  end

  blink_cmp.setup({
    keymap = {
      ["<C-space>"] = { "show" },
      ["<C-k>"] = { "select_prev", "fallback" },
      ["<C-j>"] = { "select_next", "fallback" },
      ["<C-l>"] = { "select_and_accept", "snippet_forward", "fallback" },
      ["<C-h>"] = { "snippet_backward", "fallback" },
      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      ["<C-c>"] = { "cancel", "fallback" },
      -- Don't use Tab to jump in snippets.
      ["<Tab>"] = {},
      ["<S-Tab>"] = {},
    },
    -- Disable command line completion at it breaks tab
    cmdline = {
      enabled = true,
      keymap = {
        preset = "none",
        ["<C-space>"] = { "show" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-l>"] = { "select_and_accept", "fallback" },
      },
    },
    completion = {
      trigger = {
        -- Disable automatic completion
        show_on_keyword = true,
        show_on_trigger_character = true,
        -- Don't show them when in the snippet
        show_in_snippet = false,
      },
      accept = {
        -- Accepting should not break up the undo history, it should be part of a single insert.
        create_undo_point = false,
        auto_brackets = {
          enabled = true,
        },
      },
      menu = {
        auto_show = false,
        draw = {
          columns = function(ctx)
            if ctx.mode == "cmdline" then
              -- Don't show the icon / source in the cmdline since there is only one source.
              return { { "label", "label_description", gap = 1 } }
            else
              return { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "source" } }
            end
          end,
          components = {
            source = {
              ellipsis = false,
              text = function(ctx)
                local name = source_names[ctx.item.source_id] or ctx.item.source_name
                return string.format("[%s]", name)
              end,
              highlight = "BlinkCmpSource",
            },
          },
        },
        -- Almost the same as the default, but slightly moved to take padding of noice into account.
        cmdline_position = function()
          if vim.g.ui_cmdline_pos ~= nil then
            local pos = vim.g.ui_cmdline_pos -- (1, 0)-indexed
            return { pos[1], pos[2] - 3 }
          end
          local height = (vim.o.cmdheight == 0) and 1 or vim.o.cmdheight
          return { vim.o.lines - height, 0 }
        end,
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 0,
        window = {
          border = borders.hover,
        },
      },
      ghost_text = {
        enabled = true,
      },
    },
    sources = {
      default = {
        "lsp",
        "path",
        "buffer",
        "snippets",
        "lazydev",
        -- NOTE(blink-v2): Doesn't support blink v2.
        -- "emoji"
      },
      providers = {
        buffer = {
          max_items = 8,
          score_offset = -5,
        },
        lsp = {
          -- Buffer should always be shown, but with a lower priority (listed as a fallback by default)
          fallbacks = {},
        },
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          fallbacks = { "lsp" },
        },
        emoji = {
          module = "blink-emoji",
          name = "Emoji",
        },
      },
    },
    appearance = {
      -- Prefer my icons where applicable (to be consistent)
      kind_icons = icons.lsp_kind,
    },
  })
end

function M.keys()
  local snippets = require("utils.snippets")
  imap("<C-h>", snippets.jump_backward, { desc = "Snippet » Previous" })
  smap("<C-h>", snippets.jump_backward, { desc = "Snippet » Previous" })
  imap("<C-l>", snippets.expand_or_jump_forward, { desc = "Snippet » Next" })
  smap("<C-l>", snippets.expand_or_jump_forward, { desc = "Snippet » Next" })
end

return M
