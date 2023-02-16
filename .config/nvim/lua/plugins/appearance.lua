return {
  -- Icons for many things, requires a Nerd Font
  "kyazdani42/nvim-web-devicons",
  -- Status line
  {
    "hoob3rt/lualine.nvim",
    dependencies = { "kyazdani42/nvim-web-devicons" },
    config = function()
      require("config.statusline").setup()
    end,
  },
  -- Buffer/Tabs
  {
    "akinsho/nvim-bufferline.lua",
    dependencies = { "kyazdani42/nvim-web-devicons" },
    config = function()
      require("config.bufferline").setup()
    end,
  },
  -- Show buffer name similar to a winbar but with floating window
  {
    "b0o/incline.nvim",
    config = function()
      require("config.winbar").setup()
    end,
  },
  -- Highlight colour definitions (e.g. Blue, #555d60)
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
  },
  -- Improved UI for vim.ui.select and vim.ui.input (e.g. floating window for LSP rename)
  {
    "stevearc/dressing.nvim",
    config = function()
      require("dressing").setup({ input = { insert_only = false } })
    end,
  },
  {
    "folke/noice.nvim",
    config = function()
      require("config.noice").setup()
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
  },
}
