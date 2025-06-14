local mason = require("mason")
local mason_lsp = require("mason-lspconfig")
local schemastore = require("schemastore")
local blink_cmp = require("blink.cmp")
local trouble = require("trouble")
local glance = require("glance")
local lightbulb = require("nvim-lightbulb")
local lsp_mappings = require("mappings.lsp")
local icons = require("icons")
local borders = require("borders")
local inlay_hints = require("utils.inlay_hints")

local M = {
  inlay_hints_enabled = true,
}
local SERVERS = {
  "html",
  "cssls",
  "jsonls",
  "yamlls",
  "bashls",
  "cmake",
  "lua_ls",
  "ts_ls",
  "texlab",
  "dockerls",
  "gopls",
  -- Ruff is used for linting of Python files (much faster than flake8)
  "ruff",
  -- Zig
  "zls",
  -- XML
  "lemminx",
  -- A better version of pyright
  "basedpyright",
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

-- LSP custom configs for various servers
local server_configs = {
  ccls = {
    init_options = {
      cache = {
        directory = "/tmp/ccls",
      },
    },
  },
  jsonls = {
    settings = {
      json = {
        schemas = schemastore.json.schemas(),
      },
    },
  },
  yamlls = {
    settings = {
      yaml = {
        -- Don't enfore key order, no idea why this is enabled by default.
        keyOrdering = false,
      },
    },
  },
  lua_ls = {
    settings = {
      Lua = {
        hint = {
          enable = true,
        },
      },
    },
  },
  basedpyright = {
    settings = {
      basedpyright = {
        -- Set the default type checking mode to standard, because opening a project without any configuration,
        -- will be full of errors, because most of them don't follow the basic type checking rules, let alone the much
        -- stricter ones.
        -- This makes it at least bearable for untyped code bases.
        typeCheckingMode = "standard",
      },
    },
  },
  ["rust-analyzer"] = {
    settings = {
      ["rust-analyzer"] = {
        checkOnSave = {
          command = "clippy",
          extraArgs = { "--no-deps" },
          allFeatures = true,
        },
      },
    },
  },
}

-- Setup all installed servers
function M.configure_servers()
  for server_name, config in pairs(server_configs) do
    vim.lsp.config(server_name, config)
  end
end

-- Show the source and code as a suffix for diagnostics.
-- Note: Float accepts a tuple of of two (msg, highlight) whereas
-- virtual text only uses the message. But since in lua additional
-- return values are ignored, this can be used for both.
local function diagnostic_suffix(diag)
  local parts = { " ⌁", diag.source }
  if diag.code then
    table.insert(parts, string.format("[%s]", diag.code))
  end
  local suffix = table.concat(parts, " ")
  return suffix, "Comment"
end

function M.setup()
  local virtual_text = {
    prefix = icons.arrow.hook,
    spacing = 2,
    suffix = diagnostic_suffix,
  }
  vim.diagnostic.config({
    severity_sort = true,
    virtual_text = virtual_text,
    -- Disable virtual lines by default, as they will be toggled manually when desired.
    virtual_lines = false,
    -- This is used for toggling between them as the default "on" config, the other will be set to false
    config_when_enabled = {
      virtual_text = virtual_text,
      virtual_lines = true, -- { only_current_line = true },
    },
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = icons.pad_left(icons.diagnostic.Error, 1),
        [vim.diagnostic.severity.WARN] = icons.pad_left(icons.diagnostic.Warn, 1),
        [vim.diagnostic.severity.HINT] = icons.pad_left(icons.diagnostic.Hint, 1),
        [vim.diagnostic.severity.INFO] = icons.pad_left(icons.diagnostic.Info, 1),
      },
      -- Highlight the line number as well as the diagnostic sign
      numhl = {
        [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
        [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
        [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
        [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
      },
    },
    float = {
      border = borders.hover,
      suffix = diagnostic_suffix,
    },
  })

  mason.setup({
    ui = {
      icons = icons.mason,
      border = borders.default,
    },
  })
  mason_lsp.setup({
    ensure_installed = SERVERS,
  })

  M.configure_servers()

  vim.g.rustaceanvim = {
    tools = {
      hover_actions = {
        auto_focus = true,
      },
    },
  }

  -- Completion
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
      default = { "lsp", "path", "buffer", "snippets", "lazydev", "emoji" },
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

  trouble.setup({
    use_diagnostic_signs = true,
    indent_lines = true,
    keys = {
      ["="] = "fold_toggle",
    },
    icons = {
      -- Prefer my icons where applicable (to be consistent)
      -- There are some additional kinds, that will fallback to Trouble's.
      kinds = icons.lsp_kind,
    },
  })

  lightbulb.setup({
    sign = {
      text = icons.bulb,
      hl = "DiagnosticSignWarn",
    },
  })

  glance.setup({
    height = 24,
    border = {
      enable = true,
    },
    mappings = {
      list = {
        ["<C-h>"] = glance.actions.enter_win("preview"),
        -- It might look weird to have the mapping to select itself, but that's just to overwrite the window
        -- switching as that would go outside of the glance window into a regular one.
        ["<C-l>"] = glance.actions.enter_win("list"),
        ["gq"] = glance.actions.close,
      },
      preview = {
        ["<C-h>"] = glance.actions.enter_win("preview"),
        ["<C-l>"] = glance.actions.enter_win("list"),
        ["gq"] = glance.actions.close,
      },
    },
  })

  inlay_hints.register_autocmd()

  lsp_mappings.enable_mappings()
end

return M
