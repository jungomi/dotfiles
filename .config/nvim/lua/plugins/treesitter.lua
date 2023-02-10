return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("config.treesitter").setup()
    end,
    dependencies = {
      "nvim-treesitter/playground",
      "JoosepAlviste/nvim-ts-context-commentstring",
      -- Spellcheck based on TreeSitter nodes (e.g. comment only)
      "lewis6991/spellsitter.nvim",
      -- Generate DocStrings
      "danymat/neogen",
    },
  },
}
