return {
  "neovim/nvim-lspconfig",
  -- Highlight current parameter during signature help
  "ray-x/lsp_signature.nvim",
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
  -- Progress bar/window for LSP servers
  "j-hui/fidget.nvim",
  -- Use other sources for LSP actions
  -- Mainly formatting Lua - not part of the language server for some reason
  "jose-elias-alvarez/null-ls.nvim",
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
