local lsp_config = require("lspconfig")
-- Needs to be lspconfig/configs not lspconfig.configs because of caching
-- Extending it will not work if it's a dot (.) because the source
-- uses slash (/) and therefore has a different table
local server_configs = require("lspconfig/configs")
local lsp_install = require("lspinstall")
local lsp_saga = require("lspsaga")
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
local LANGS = {
  "html",
  "css",
  "json",
  "yaml",
  "bash",
  "cmake",
  "lua",
  "typescript",
  "latex",
  "dockerfile",
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
  TypeParameter = " ",
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

-- LSP Configs that are not in nimv-lspconfig
local additional_configs = {
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

local function on_attach()
  lsp_signature.on_attach({})
end

local default_config = {
  on_attach = on_attach,
  capabilities = capabilities,
}

-- Setup all installed servers
function M.setup_servers()
  lsp_install.setup()
  local installed_servers = lsp_install.installed_servers()
  -- Add additional configs that are not installed with lsp-install
  for name, config in pairs(additional_configs) do
    extend_lsp_config(name, config)
    table.insert(installed_servers, name)
  end
  for _, server in pairs(installed_servers) do
    if server == "lua" then
      -- For the nvim lua integration the config needs to extended
      lsp_config[server].setup(lua_dev.setup({ lspconfig = default_config }))
    else
      lsp_config[server].setup(vim.tbl_deep_extend("force", {}, default_config, additional_configs[server] or {}))
    end
  end
end

-- Automatically install servers for the specified languages
function M.install_servers(langs)
  local installed_servers = lsp_install.installed_servers()
  for _, lang in pairs(langs) do
    if not vim.tbl_contains(installed_servers, lang) then
      lsp_install.install_server(lang)
    end
  end
end

-- Automatically reload after `:LspInstall <server>`
lsp_install.post_install_hook = function()
  M.setup_servers()
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
  M.install_servers(LANGS)
  M.setup_servers()

  null_ls.setup({
    -- Don't save when calling lsp/format
    save_after_format = false,
    sources = {
      null_ls.builtins.formatting.stylua.with({
        args = { "--search-parent-directories", "--stdin-filepath", "$FILENAME", "-" },
      }),
    },
  })

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

  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    -- Configure appearance of virtual text diagnostics
    virtual_text = {
      prefix = "↪",
      spacing = 2,
    },
  })

  lsp_saga.init_lsp_saga({
    error_sign = " ",
    warn_sign = " ",
    infor_sign = " ",
    hint_sign = " ",
    code_action_icon = " ",
    -- Don't show the virtual text bulb, only the sign
    code_action_prompt = { virtual_text = false },
    border_style = "round",
    rename_prompt_prefix = "﬌",
  })

  -- Completion
  cmp.setup({
    completion = {
      autocomplete = false,
    },
    documentation = {
      border = "rounded",
    },
    sources = {
      { name = "path" },
      {
        name = "buffer",
        opts = {
          get_bufnrs = function()
            -- Complete from all buffers, not just the current or the visible ones
            return vim.api.nvim_list_bufs()
          end,
        },
      },
      { name = "calc" },
      { name = "nvim_lsp" },
      { name = "nvim_lua" },
      { name = "vsnip" },
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
          vim_item.kind = string.format("%s [%s]", vim_item.kind, name)
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
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-l>"] = cmp.mapping(function()
        if vim.fn.pumvisible() == 1 then
          if not cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }) then
            vim.fn.feedkeys(t("<C-y>"), "n")
          end
        elseif vim.fn["vsnip#available"](1) == 1 then
          vim.fn.feedkeys(t("<Plug>(vsnip-expand-or-jump)"), "")
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

  -- Highlight the line number as well as the diagnostic sign
  vim.fn.sign_define("LspDiagnosticsSignError", { numhl = "LspDiagnosticsSignError" })
  vim.fn.sign_define("LspDiagnosticsSignWarning", { numhl = "LspDiagnosticsSignWarning" })
  vim.fn.sign_define("LspDiagnosticsSignHint", { numhl = "LspDiagnosticsSignHint" })
  vim.fn.sign_define("LspDiagnosticsSignInformation", { numhl = "LspDiagnosticsSignInformation" })

  M.overwrite_diagnostic_priority()

  lsp_mappings.enable_mappings()
end

return M
