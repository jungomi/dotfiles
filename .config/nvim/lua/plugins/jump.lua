return {
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    config = function()
      require("config.jump").setup()
    end,
  },
}
