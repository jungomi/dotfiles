return {
  {
    "zbirenbaum/copilot.lua",
    opts = {
      server_opts_overrides = {
        settings = {
          telemetry = {
            telemetryLevel = "off",
          },
        },
      },
    },
  },
  {
    "ravitemer/mcphub.nvim",
    -- Lazy load, since that starts a node server that uses a lot of unnecessary memory.
    -- I don't care for MCP most of the time, and if I want to use them I'll just startt them.
    -- Also works when codecompanion.nvim registers the extension.
    cmd = "MCPHub",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    build = "npm install -g mcp-hub@latest",
    opts = {
      -- Do not delay shutting down the server. There is no reason for me to keep it alive after exiting neovim.
      shutdown_delay = 0,
    },
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
