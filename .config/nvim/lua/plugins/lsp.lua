local icons = require("icons")

return {
  "neovim/nvim-lspconfig",
  -- Completion
  {
    "saghen/blink.cmp",
    lazy = false,
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    build = "cargo build --release",
  },
  -- Pretty list of diagnostics (quickfix with style)
  {
    "folke/trouble.nvim",
    dependencies = { "kyazdani42/nvim-web-devicons" },
  },
  -- Show a lightbulb sign if a code action is available for the current line
  "kosayoda/nvim-lightbulb",
  -- Preview LSP references / definitions etc in a neat floating window
  "dnlhc/glance.nvim",
  -- Virtual lines below instead of just virtual text at the end
  "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
  {
    -- Formatter with fallback to LSP formatting
    -- Makes it easy to use formatters that are not included in the language server
    -- or allows to take precedence.
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        css = { "prettier" },
        markdown = { "prettier" },
        javascript = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        yaml = { "prettier" },
        go = { "goimports", "gofumpt" },
        -- Even though there is a ruff-lsp that does the formatting, it always operates
        -- on the whole, whereas conform only applies the changes, which preverves marks etc.
        python = { "ruff_fix_imports", "ruff_format" },
      },
      formatters = {
        -- This is Ruff's fix with the isort rules enforced, which results in them being sorted.
        -- It is purely used to sort the imports by default, otherwise it would rely on the
        -- project to have it configured in pyproject.toml.
        ruff_fix_imports = function()
          local ruff = vim.deepcopy(require("conform.formatters.ruff_fix"))
          table.insert(ruff.args, "--extend-select")
          table.insert(ruff.args, "I")
          return ruff
        end,
      },
    },
  },
  -- Rust integrations
  "mrcjkb/rustaceanvim",
  -- Lua LSP to recognise nvim API
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- Types for vim.uv, not currently available in upstream neovim.
        "luvit-meta/library",
      },
    },
    dependencies = {
      { "Bilal2453/luvit-meta", lazy = true },
    },
  },
  -- Schemas for JSON files to complete/display configurations options
  "b0o/SchemaStore.nvim",
  -- A package manager integrated into NeoVim (to install external dependencies)
  "williamboman/mason.nvim",
  -- Install language servers automatically
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("config.lsp").setup()
    end,
  },
  {
    "chrisgrieser/nvim-lsp-endhints",
    event = "LspAttach",
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
}
