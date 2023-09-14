return {
  "neovim/nvim-lspconfig",
  -- Completion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-calc",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-vsnip",
      "andersevenrud/cmp-tmux",
    },
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
        javascript = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        go = { "goimports", "gofumpt" },
      },
    },
  },
  -- Rust integrations
  {
    "simrat39/rust-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  -- Lua to recognise nvim API
  "folke/neodev.nvim",
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
}
