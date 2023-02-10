return {
  -- Commenting out code
  {
    "numToStr/Comment.nvim",
    config = function()
      require("config.comment").setup()
    end,
  },
  -- Yank over SSH with ANSI OSC52 escape sequence
  "ojroques/nvim-osc52",
  -- Smooth scrolling
  {
    "karb94/neoscroll.nvim",
    config = function()
      require("config.scrolling").setup()
    end,
  },
  -- Custom modes (continuous actions) e.g. resizing mode
  {
    "anuvyklack/hydra.nvim",
    dependencies = { "anuvyklack/keymap-layer.nvim" },
    config = function()
      require("config.hydra").setup()
    end,
  },
}
