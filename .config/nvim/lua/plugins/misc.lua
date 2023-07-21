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
          -- Disable some unused ones (they get in the way of mostly operator pending mappings)
          -- Also mostly line based (i.e. inserting the brackets around the line, instead of around the selection)
          normal_line = false,
          normal_cur_line = false,
          -- BUG: cannot set this to false, otherwise the change (sr) mapping doesn't work,
          -- so just have it on srs which I'll probbably never use, but at least it's not interferring.
          change_line = "srs",
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
