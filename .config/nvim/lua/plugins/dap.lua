return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "mfussenegger/nvim-dap-python",
        -- Need to disable the build, because Lazy 11.0 now tries to build the plugin if there is a rockspec.
        -- But this plugin has rockspec that is not for the plugin but mainly for testing, so it cannot be installed
        -- with it, therefore disable trying to build it.
        build = false,
      },
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
      "rcarriga/nvim-dap-ui",
    },
    config = function()
      require("config.dap").setup()
    end,
  },
}
