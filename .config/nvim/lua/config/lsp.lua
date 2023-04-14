local lsp_config = require("lspconfig")
local mason = require("mason")
local mason_lsp = require("mason-lspconfig")
local null_ls = require("null-ls")
local neodev = require("neodev")
local rust_tools = require("rust-tools")
local schemastore = require("schemastore")
local cmp = require("cmp")
local cmp_lsp = require("cmp_nvim_lsp")
local trouble = require("trouble")
local lsp_lines = require("lsp_lines")
local lsp_mappings = require("mappings.lsp")
local t = require("utils.map").t

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
}

local kind_icons = {
  Class = "⚛",
  Color = "",
  Constant = "",
  Constructor = "",
  Enum = "",
  EnumMember = "",
  Event = "",
  Field = "",
  File = "",
  Folder = "",
  Function = "⨍",
  Interface = "↯",
  Keyword = "",
  Method = "⨍",
  Module = "",
  Operator = "",
  Property = "",
  Reference = "",
  Snippet = "✐",
  Struct = "",
  Text = "",
  TypeParameter = "",
  Unit = "",
  Value = "",
  Variable = "≝",
}

-- Source names to be shown in the completion menu
local source_names = {
  path = "File",
  buffer = "Buff",
  calc = "Calc",
  nvim_lsp = "LSP",
  nvim_lua = "Lua",
  vsnip = "Snip",
  tmux = "Tmux",
}

local function on_attach()
  -- Currently empty by default, as the ones used previously are no longer necessary.
end

local function on_attach_no_fmt(client)
  -- For future versions
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false
  -- Call the default on_attach
  on_attach()
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
          -- Disable autopep8 and yapf, because black is used for formatting.
          autopep8 = {
            enabled = false,
          },
          yapf = {
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
  gopls = {
    on_attach = on_attach_no_fmt,
  },
  lua_ls = {
    on_attach = on_attach_no_fmt,
  },
  tsserver = {
    on_attach = on_attach_no_fmt,
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
    prefix = "↪",
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
      icons = {
        server_installed = "✓",
        server_pending = "⟳",
        server_uninstalled = "",
      },
    },
  })
  mason_lsp.setup({
    ensure_installed = SERVERS,
  })

  neodev.setup({})
  M.setup_servers()

  null_ls.setup({
    -- Don't save when calling lsp/format
    save_after_format = false,
    sources = {
      null_ls.builtins.formatting.stylua.with({
        args = { "--search-parent-directories", "--stdin-filepath", "$FILENAME", "-" },
      }),
      null_ls.builtins.formatting.prettier,
      null_ls.builtins.diagnostics.eslint,
      null_ls.builtins.formatting.goimports,
      null_ls.builtins.formatting.gofumpt,
    },
  })

  rust_tools.setup({
    tools = {
      hover_actions = {
        auto_focus = true,
      },
      inlay_hints = {
        other_hints_prefix = "  ‣ ",
        parameter_hints_prefix = "  ⨍",
        highlight = "DiagnosticVirtualTextHint",
        -- Disable parameter hints, because currently they are not
        -- showing consistently on every parameter.
        show_parameter_hints = false,
      },
    },
    server = {
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        ["rust-analyzer"] = {
          checkOnSave = {
            command = "clippy",
            allFeatures = true,
          },
        },
      },
    },
  })

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
    },
    sources = cmp.config.sources({
      -- The order defines the priority during the completion
      { name = "nvim_lsp" },
      { name = "nvim_lua" },
      { name = "vsnip" },
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
      format = function(entry, vim_item)
        local icon = kind_icons[vim_item.kind]
        if icon then
          vim_item.kind = icon
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
        -- Complete snippets with vsnip
        vim.fn["vsnip#anonymous"](args.body)
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
        elseif vim.fn["vsnip#available"](1) == 1 then
          vim.fn.feedkeys(t("<Plug>(vsnip-expand-or-jump)"))
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

  trouble.setup({
    use_diagnostic_signs = true,
    indent_lines = true,
  })

  lsp_lines.setup()

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    -- Configure appearance of floating windows from hover info
    border = "rounded",
  })

  -- Highlight the line number as well as the diagnostic sign
  vim.fn.sign_define(
    "DiagnosticSignError",
    { text = " ", texthl = "DiagnosticSignError", numhl = "DiagnosticSignError" }
  )
  vim.fn.sign_define(
    "DiagnosticSignWarn",
    { text = " ", texthl = "DiagnosticSignWarn", numhl = "DiagnosticSignWarn" }
  )
  vim.fn.sign_define(
    "DiagnosticSignHint",
    { text = " ", texthl = "DiagnosticSignHint", numhl = "DiagnosticSignHint" }
  )
  vim.fn.sign_define(
    "DiagnosticSignInfo",
    { text = " ", texthl = "DiagnosticSignInfo", numhl = "DiagnosticSignInfo" }
  )

  -- Lightbulb for code actions
  vim.fn.sign_define("LightBulbSign", { text = "💡", texthl = "DiagnosticSignWarn" })

  lsp_mappings.enable_mappings()
end

return M
