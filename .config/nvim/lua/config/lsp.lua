local lsp_config = require("lspconfig")
local mason = require("mason")
local mason_lsp = require("mason-lspconfig")
local neodev = require("neodev")
local schemastore = require("schemastore")
local cmp = require("cmp")
local cmp_lsp = require("cmp_nvim_lsp")
local luasnip = require("luasnip")
local luasnip_vscode = require("luasnip.loaders.from_vscode")
local trouble = require("trouble")
local glance = require("glance")
local lsp_lines = require("lsp_lines")
local lightbulb = require("nvim-lightbulb")
local inlay_hints = require("lsp-inlayhints")
local lsp_mappings = require("mappings.lsp")
local icons = require("icons")

local M = {}
local SERVERS = {
  "html",
  "cssls",
  "jsonls",
  "yamlls",
  "bashls",
  "cmake",
  "lua_ls",
  "tsserver",
  "texlab",
  "dockerls",
  "gopls",
  -- Ruff is used for linting of Python files (much faster than flake8)
  "ruff_lsp",
  -- Zig
  "zls",
}

-- Source names to be shown in the completion menu
local source_names = {
  path = "File",
  buffer = "Buff",
  calc = "Calc",
  nvim_lsp = "LSP",
  nvim_lua = "Lua",
  luasnip = "Snip",
  tmux = "Tmux",
}

local function on_attach(client, bufnr)
  -- Currently empty by default, as the ones used previously are no longer necessary.
  inlay_hints.on_attach(client, bufnr)
end

-- LSP custom configs for various servers
local custom_server_configs = {
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
  pylsp = {
    settings = {
      pylsp = {
        plugins = {
          -- Turn off all linters because ruff is used separately
          flake8 = {
            enabled = false,
          },
          pyflakes = {
            enabled = false,
          },
          pycodestyle = {
            enabled = false,
          },
          -- Disable autopep8, yapf, black and isort because ruff is now used for formatting.
          autopep8 = {
            enabled = false,
          },
          yapf = {
            enabled = false,
          },
          black = {
            enabled = false,
          },
          isort = {
            enabled = false,
          },
          -- Disable cyclomatic complexity analysis
          mccabe = {
            enabled = false,
          },
        },
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
}

-- More capabilities are supported by nvim-cmp, such as Snippets
local capabilities = cmp_lsp.default_capabilities()

local default_config = {
  on_attach = on_attach,
  capabilities = capabilities,
}

-- Setup all installed servers
function M.setup_servers()
  local server_configs = vim.deepcopy(custom_server_configs)
  for _, server_name in ipairs(SERVERS) do
    if not server_configs[server_name] then
      -- Use an empty config for the installed servers without a custom config
      server_configs[server_name] = {}
    end
  end
  for server_name, config in pairs(server_configs) do
    local opts = vim.tbl_deep_extend("force", {}, default_config, config)
    lsp_config[server_name].setup(opts)
  end
end

function M.setup()
  local virtual_text = {
    prefix = icons.arrow.hook,
    spacing = 2,
    format = function(diag)
      local parts = { diag.message, "⌁", diag.source }
      if diag.code then
        table.insert(parts, string.format("(%s)", diag.code))
      end
      return table.concat(parts, " ")
    end,
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
  })

  mason.setup({
    ui = {
      icons = icons.mason,
      border = "rounded",
    },
  })
  mason_lsp.setup({
    ensure_installed = SERVERS,
  })

  neodev.setup({})
  M.setup_servers()

  inlay_hints.setup({
    inlay_hints = {
      parameter_hints = {
        -- Disable parameter hints, because it doesn't work if they are at the end of the line.
        -- Will enable them once 0.10 is released, which supports true inlay hints.
        show = false,
        prefix = icons.pad_left(icons.lsp_kind.Function, 2),
      },
      type_hints = {
        prefix = icons.pad(icons.triangle.tiny, 2, 1),
        remove_colon_start = true,
      },
    },
  })
  vim.g.rustaceanvim = {
    tools = {
      hover_actions = {
        auto_focus = true,
      },
    },
    server = {
      on_attach = on_attach,
      capabilities = capabilities,
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

  -- Completion
  cmp.setup({
    experimental = {
      ghost_text = true,
    },
    completion = {
      autocomplete = false,
    },
    window = {
      documentation = {
        border = "rounded",
      },
      completion = {
        col_offset = -3,
        side_padding = 0,
      },
    },
    sources = cmp.config.sources({
      -- The order defines the priority during the completion
      { name = "nvim_lsp" },
      { name = "nvim_lua" },
      { name = "luasnip" },
      { name = "path" },
      { name = "calc" },
      {
        name = "buffer",
        option = {
          get_bufnrs = function()
            -- Complete from all buffers, not just the current or the visible ones
            return vim.api.nvim_list_bufs()
          end,
        },
      },
    }, {
      -- This is a separate group, meaning that it will only be triggered when the
      -- there is no match from the group above.
      -- Tmux priority was just way out of order, but I occasionally still use it,
      -- mostly for something that is not matched anyway.
      {
        name = "tmux",
        option = {
          -- Complete from all panes not just the visible ones
          all_panes = true,
        },
      },
    }),
    formatting = {
      fields = { "kind", "abbr", "menu" },
      format = function(entry, vim_item)
        local icon = icons.lsp_kind[vim_item.kind]
        if icon then
          vim_item.kind = string.format(" %s ", icon)
        end
        if entry.source.name then
          local name = source_names[entry.source.name] or entry.source.name
          vim_item.menu = string.format("[%s]", name)
        end
        return vim_item
      end,
    },
    snippet = {
      expand = function(args)
        -- Complete snippets with luasnip
        luasnip.lsp_expand(args.body)
      end,
    },
    mapping = {
      ["<C-Space>"] = cmp.mapping(cmp.mapping.complete({}), { "i", "c" }),
      ["<C-j>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        else
          fallback()
        end
      end, {
        "i",
        "s",
        "c",
      }),
      ["<C-k>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end, {
        "i",
        "s",
        "c",
      }),
      ["<C-l>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
        else
          fallback()
        end
      end, {
        "i",
        "s",
        "c",
      }),
    },
  })

  -- Load snippets from RTP (from friendly-snippets) and my custom snippets
  luasnip_vscode.lazy_load()
  luasnip_vscode.lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })

  trouble.setup({
    use_diagnostic_signs = true,
    indent_lines = true,
  })

  lsp_lines.setup()

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

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    -- Configure appearance of floating windows from hover info
    border = "rounded",
  })

  -- Highlight the line number as well as the diagnostic sign
  vim.fn.sign_define(
    "DiagnosticSignError",
    { text = icons.pad_left(icons.diagnostic.Error, 1), texthl = "DiagnosticSignError", numhl = "DiagnosticSignError" }
  )
  vim.fn.sign_define(
    "DiagnosticSignWarn",
    { text = icons.pad_left(icons.diagnostic.Warn, 1), texthl = "DiagnosticSignWarn", numhl = "DiagnosticSignWarn" }
  )
  vim.fn.sign_define(
    "DiagnosticSignHint",
    { text = icons.pad_left(icons.diagnostic.Hint, 1), texthl = "DiagnosticSignHint", numhl = "DiagnosticSignHint" }
  )
  vim.fn.sign_define(
    "DiagnosticSignInfo",
    { text = icons.pad_left(icons.diagnostic.Info, 1), texthl = "DiagnosticSignInfo", numhl = "DiagnosticSignInfo" }
  )

  -- Show border around commands like LspInfo
  require("lspconfig.ui.windows").default_options.border = "rounded"

  lsp_mappings.enable_mappings()
end

return M
