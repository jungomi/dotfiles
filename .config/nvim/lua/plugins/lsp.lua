local icons = require("icons")
local borders = require("borders")
local map_utils = require("utils.map")
local nmap = map_utils.nmap
local imap = map_utils.imap

local SERVERS = {
  "html",
  "cssls",
  "jsonls",
  "yamlls",
  "bashls",
  "cmake",
  "emmylua_ls",
  "tsc",
  "texlab",
  "dockerls",
  -- Ruff is used for linting of Python files (much faster than flake8)
  "ruff",
  -- Zig
  "zls",
  -- XML
  "lemminx",
  -- Python type checker (submodule of ruff)
  "ty",
  -- Typst
  "tinymist",
}

-- Show the source and code as a suffix for diagnostics.
-- Note: Float accepts a tuple of two (msg, highlight) whereas
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

local function toggle_virtual_lines()
  local cfg = vim.diagnostic.config()
  if cfg.virtual_text then
    vim.diagnostic.config({ virtual_text = false, virtual_lines = cfg.config_when_enabled.virtual_lines })
  else
    vim.diagnostic.config({ virtual_text = cfg.config_when_enabled.virtual_text, virtual_lines = false })
  end
end

local lspconfig_spec = {
  "neovim/nvim-lspconfig",
  config = function()
    local schemastore = require("schemastore")

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
      tinymist = {
        settings = {
          formatterMode = "typstyle",
        },
      },
    }

    for server_name, config in pairs(server_configs) do
      vim.lsp.config(server_name, config)
    end

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

    local inlay_hints = require("utils.inlay_hints")
    inlay_hints.register_autocmd()
  end,
  keys = function()
    local inlay_hints = require("utils.inlay_hints")
    -- Go to definition
    nmap("<leader>ld", vim.lsp.buf.definition, { desc = "LSP » Go to definition" })
    -- Highlight references
    nmap("<leader>lh", vim.lsp.buf.document_highlight, { desc = "LSP » Highlight references" })
    nmap("<leader>lr", vim.lsp.buf.rename, { desc = "LSP » Rename" })
    -- Show type info of the word under the cursor
    nmap("<leader>lt", vim.lsp.buf.hover, { desc = "LSP » Hover info" })
    -- signature help is called in a function rather than given directly, because it will be overwritten by noice.
    -- If the function is given directly, it can still be the old one, if this was executed before it was patched.
    nmap("<leader>ls", function()
      vim.lsp.buf.signature_help()
    end, { desc = "LSP » Signature" })
    imap("<C-s>", function()
      vim.lsp.buf.signature_help()
    end, { desc = "LSP » Signature" })
    nmap("<leader>la", vim.lsp.buf.code_action, { desc = "LSP » Code actions" })
    nmap("<leader>lv", toggle_virtual_lines, { desc = "LSP » Toggle Virtual Lines" })
    nmap("<leader>li", inlay_hints.cycle, { desc = "LSP » Toggle Inlay Hints" })
    -- Diagnostic navigation
    nmap("]d", function()
      vim.diagnostic.jump({ count = 1, float = true })
    end, { desc = "LSP » Jump to next diagnostic" })
    nmap("[d", function()
      vim.diagnostic.jump({ count = -1, float = true })
    end, { desc = "LSP » Jump to previous diagnostic" })
  end,
}

return {
  -- Schemas for JSON files to complete/display configurations options
  "b0o/SchemaStore.nvim",
  lspconfig_spec,

  -- Completion
  "saghen/blink.lib",
  require("plugins.blink"),
  "rafamadriz/friendly-snippets",

  -- Pretty list of diagnostics (quickfix with style)
  {
    "folke/trouble.nvim",
    opts = {
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
    },
    keys = function()
      nmap("<leader>cd", "<Cmd>Trouble diagnostics toggle<CR>", { desc = "Trouble » Diagnostics" })
      nmap("<leader>cq", "<Cmd>Trouble qflist toggle<CR>", { desc = "Trouble » Quickfix" })
      nmap("<leader>cl", "<Cmd>Trouble loclist toggle<CR>", { desc = "Trouble » Location List" })
      nmap(
        "<leader>cs",
        "<Cmd>Trouble symbols toggle win.size.width=60 pinned=true<CR>",
        { desc = "Trouble » Symbols" }
      )
      nmap("<leader>cf", "<Cmd>Trouble focus<CR>", { desc = "Trouble » Focus" })
    end,
  },

  -- Show a lightbulb sign if a code action is available for the current line
  {
    "kosayoda/nvim-lightbulb",
    opts = {
      sign = {
        text = icons.bulb,
        hl = "DiagnosticSignWarn",
      },
    },
  },

  -- Preview LSP references / definitions etc in a neat floating window
  require("plugins.glance"),

  -- Formatter with fallback to LSP formatting
  -- Makes it easy to use formatters that are not included in the language server
  -- or allows to take precedence.
  require("plugins.conform"),

  -- Rust integrations
  {
    "mrcjkb/rustaceanvim",
    config = function()
      vim.g.rustaceanvim = {
        tools = {
          hover_actions = {
            auto_focus = true,
          },
        },
      }
    end,
  },

  -- Lua LSP to recognise nvim API
  {
    "folke/lazydev.nvim",
    opts = {
      library = {
        -- Types for vim.uv, not currently available in upstream neovim.
        "luvit-meta/library",
      },
    },
  },
  "Bilal2453/luvit-meta",

  -- A package manager integrated into NeoVim (to install external dependencies)
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({
        ui = {
          icons = icons.mason,
          border = borders.default,
        },
      })
    end,
  },

  -- Install language servers automatically
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = SERVERS,
    },
  },

  {
    "chrisgrieser/nvim-lsp-endhints",
    opts = {
      icons = {
        type = icons.pad_right(icons.triangle.tiny, 1),
        parameter = icons.lsp_kind.Function,
        offspec = icons.pad_right(icons.triangle.tiny, 1),
        unknown = icons.pad_right(icons.triangle.tiny, 1),
      },
      label = {
        truncateAtChars = 45,
        padding = 2,
      },
    },
  },

  {
    "chomosuke/typst-preview.nvim",
    opts = {},
    keys = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "typst",
        callback = function(ev)
          nmap("<leader>mp", "<cmd>TypstPreviewToggle<cr>", { buffer = ev.buf, desc = "Typst Preview" })
        end,
      })
    end,
  },

  -- Markdown preview
  {
    "selimacerbas/mdkite.nvim",
    opts = {
      -- Default is "takeover" which uses the same port.
      -- Currently quite like that.
      -- instance_mode = "multi",
      default_theme = "light",
      debounce_ms = 150,
      bottom_padding = 0.7,
    },
    keys = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function(ev)
          nmap("<leader>mp", "<cmd>MdKite start<cr>", { buffer = ev.buf, desc = "Markdown Preview" })
        end,
      })
    end,
  },
  "selimacerbas/kitehost.nvim",
}
