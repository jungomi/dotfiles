local borders = require("borders")

return {
  {
    "zbirenbaum/copilot.lua",
    opts = {},
  },
  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    build = "npm install -g mcp-hub@latest",
    opts = {},
  },
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "zbirenbaum/copilot.lua",
      "folke/noice.nvim",
    },
    config = function()
      require("config.llm").setup()
    end,
  },
}
