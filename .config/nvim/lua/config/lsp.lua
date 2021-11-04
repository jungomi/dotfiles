local lsp_config = require("lspconfig")
-- Needs to be lspconfig/configs not lspconfig.configs because of caching
-- Extending it will not work if it's a dot (.) because the source
-- uses slash (/) and therefore has a different table
local server_configs = require("lspconfig/configs")
local lsp_installer = require("nvim-lsp-installer")
local lsp_installer_servers = require("nvim-lsp-installer.servers")
local lsp_signature = require("lsp_signature")
local null_ls = require("null-ls")
local lua_dev = require("lua-dev")
local rust_tools = require("rust-tools")
local cmp = require("cmp")
local cmp_lsp = require("cmp_nvim_lsp")
local trouble = require("trouble")
local lsp_utils = require("utils.lsp")
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
  "sumneko_lua",
  "tsserver",
  "texlab",
  "dockerls",
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
  lsp_signature.on_attach({})
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
  pylsp = {
    settings = {
      pylsp = {
        plugins = {
          -- Use flake8 for code style instead of pycodestyle
          flake8 = {
            enabled = true,
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
  tsserver = {
    on_attach = function(client)
      -- Disable tsserver formatting because prettier is run with null-ls
      client.resolved_capabilities.document_formatting = false
      client.resolved_capabilities.document_range_formatting = false
      -- Call the default on_attach
      on_attach()
    end,
  },
}

local function extend_lsp_config(name, config)
  -- Only extend the server config if the LSP does not have a built-in config
  if not lsp_config[name] then
    server_configs[name] = vim.tbl_deep_extend("keep", server_configs[name] or {}, config)
  end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
-- More capabilities are supported by nvim-cmp, such as Snippets
capabilities = cmp_lsp.update_capabilities(capabilities)

local default_config = {
  on_attach = on_attach,
  capabilities = capabilities,
}

-- Setup all installed servers
function M.setup_servers()
  lsp_installer.on_server_ready(function(server)
    local opts = vim.tbl_deep_extend("force", {}, default_config, custom_server_configs[server.name] or {})
    if server.name == "sumneko_lua" then
      -- For the nvim lua integration the config needs to extended
      opts = lua_dev.setup({ lspconfig = opts })
    end
    server:setup(opts)
  end)

  -- Setup additional servers that are not installed/handled by lsp-installer
  for server_name, config in pairs(custom_server_configs) do
    if not vim.tbl_contains(SERVERS, server_name) then
      -- Add a new config, the server is not even present in lsp_config
      extend_lsp_config(server_name, config)
      local opts = vim.tbl_deep_extend("force", {}, default_config, custom_server_configs[server_name] or {})
      lsp_config[server_name].setup(opts)
    end
  end
end

-- Automatically install servers for the specified languages
function M.install_servers(servers)
  -- Default to the pre-defined SERVERS if no argument is given
  servers = servers or SERVERS
  for _, server_name in pairs(servers) do
    local server_available, requested_server = lsp_installer_servers.get_server(server_name)
    if server_available then
      if not requested_server:is_installed() then
        requested_server:install()
      end
    else
      error(string.format("LSP server `%s` does not exist and canot be installed", server_name))
    end
  end
end

-- The diagnostics do not show the one with the highest severity, but instead just shows the latest.
-- To only show the one with the highest severity, setting the signs / virtual text need to be overwritten
-- to prioritise showing the ones with the highest severity.
function M.overwrite_diagnostic_priority()
  -- Capture original functions, which will be called from the overwritten functions.
  local set_signs = vim.lsp.diagnostic.set_signs
  local set_virtual_text = vim.lsp.diagnostic.set_virtual_text
  local set_underline = vim.lsp.diagnostic.set_underline
  local function set_signs_limited(diagnostics, bufnr, client_id, sign_ns, opts)
    if not diagnostics then
      return
    end
    local filtered_diagnostics = lsp_utils.filter_diagnostics_per_line_by_severity(diagnostics, true)
    -- Set signs with the original (captured) function
    set_signs(filtered_diagnostics, bufnr, client_id, sign_ns, opts)
  end
  local function set_virtual_text_limited(diagnostics, bufnr, client_id, diagnostic_ns, opts)
    if not diagnostics then
      return
    end
    local filtered_diagnostics = lsp_utils.filter_diagnostics_per_line_by_severity(diagnostics, true)
    -- Set virtual text with the original (captured) function
    set_virtual_text(filtered_diagnostics, bufnr, client_id, diagnostic_ns, opts)
  end
  local function set_underline_limited(diagnostics, bufnr, client_id, diagnostic_ns, opts)
    if not diagnostics then
      return
    end
    local filtered_diagnostics = lsp_utils.filter_diagnostics_per_line_by_severity(diagnostics)
    -- Set virtual text with the original (captured) function
    set_underline(filtered_diagnostics, bufnr, client_id, diagnostic_ns, opts)
  end
  -- Overwrite the functions
  vim.lsp.diagnostic.set_signs = set_signs_limited
  vim.lsp.diagnostic.set_virtual_text = set_virtual_text_limited
  vim.lsp.diagnostic.set_underline = set_underline_limited
end

function M.setup()
  lsp_installer.settings({
    ui = {
      icons = {
        server_installed = "✓",
        server_pending = "⟳",
        server_uninstalled = "",
      },
    },
  })
  M.install_servers(SERVERS)
  M.setup_servers()

  null_ls.config({
    -- Don't save when calling lsp/format
    save_after_format = false,
    sources = {
      null_ls.builtins.formatting.stylua.with({
        args = { "--search-parent-directories", "--stdin-filepath", "$FILENAME", "-" },
      }),
      null_ls.builtins.formatting.prettier,
      null_ls.builtins.diagnostics.eslint,
    },
  })
  lsp_config["null-ls"].setup({})

  rust_tools.setup({
    tools = {
      hover_with_actions = true,
      hover_actions = {
        auto_focus = true,
      },
      inlay_hints = {
        other_hints_prefix = "  ‣ ",
        parameter_hints_prefix = "  ⨍",
        highlight = "LspInlineHint",
        -- Disable parameter hints, because currently they are not
        -- showing consistently on every parameter.
        show_parameter_hints = false,
      },
    },
    server = {
      on_attach = on_attach,
      capabilities = capabilities,
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
    documentation = {
      border = "rounded",
    },
    sources = {
      -- The order defines the priority during the completion
      { name = "nvim_lsp" },
      { name = "nvim_lua" },
      { name = "vsnip" },
      { name = "path" },
      { name = "calc" },
      {
        name = "buffer",
        opts = {
          get_bufnrs = function()
            -- Complete from all buffers, not just the current or the visible ones
            return vim.api.nvim_list_bufs()
          end,
        },
      },
      {
        name = "tmux",
        opts = {
          -- Complete from all panes not just the visible ones
          all_panes = true,
        },
      },
    },
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
      ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
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
    use_lsp_diagnostic_signs = true,
    indent_lines = true,
  })

  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    -- Configure appearance of virtual text diagnostics
    virtual_text = {
      prefix = "↪",
      spacing = 2,
    },
  })
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    -- Configure appearance of floating windows from hover info
    border = "rounded",
  })

  -- Highlight the line number as well as the diagnostic sign
  vim.fn.sign_define("DiagnosticSignError", { text = " ", numhl = "DiagnosticSignError" })
  vim.fn.sign_define("DiagnosticSignWarn", { text = " ", numhl = "DiagnosticSignWarn" })
  vim.fn.sign_define("DiagnosticSignHint", { text = " ", numhl = "DiagnosticSignHint" })
  vim.fn.sign_define("DiagnosticSignInfo", { text = " ", numhl = "DiagnosticSignInfo" })
  -- For NeoVim 0.5 (they will change to the above in 0.6)
  vim.fn.sign_define("LspDiagnosticsSignError", { text = " ", numhl = "LspDiagnosticsSignError" })
  vim.fn.sign_define("LspDiagnosticsSignWarning", { text = " ", numhl = "LspDiagnosticsSignWarning" })
  vim.fn.sign_define("LspDiagnosticsSignHint", { text = " ", numhl = "LspDiagnosticsSignHint" })
  vim.fn.sign_define("LspDiagnosticsSignInformation", { text = " ", numhl = "LspDiagnosticsSignInformation" })

  M.overwrite_diagnostic_priority()

  lsp_mappings.enable_mappings()
end

return M
