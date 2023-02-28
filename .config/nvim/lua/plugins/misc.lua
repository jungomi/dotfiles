return {
  -- Commenting out code
  {
    "numToStr/Comment.nvim",
    config = function()
      require("config.comment").setup()
    end,
  },
  {
    "kylechui/nvim-surround",
    config = function()
      require("nvim-surround").setup({
        keymaps = {
          normal = "sa",
          normal_cur = "sas",
          delete = "sd",
          change = "sr",
        },
        -- Don't move to the opening symbol after the action.
        move_cursor = false,
      })
    end,
  },
  -- Automatically close brackets
  -- I mostly want it for blocks when pressing <CR>.
  {
    "windwp/nvim-autopairs",
    config = function()
      require("config.pairs").setup()
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
