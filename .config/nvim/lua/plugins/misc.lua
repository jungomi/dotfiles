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
  -- Smooth scrolling
  {
    "karb94/neoscroll.nvim",
    config = function()
      require("config.scrolling").setup()
    end,
  },
  -- Custom modes (continuous actions) e.g. resizing mode
  {
    "nvimtools/hydra.nvim",
    config = function()
      require("config.hydra").setup()
    end,
  },
  {
    "tzachar/highlight-undo.nvim",
    opts = {},
  },
  {
    "stevearc/oil.nvim",
    config = function()
      require("config.oil").setup()
    end,
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  -- Swap two regions of text or replace text selected by motion
  {
    "gbprod/substitute.nvim",
    config = function()
      require("config.substitute").setup()
    end,
  },
  {
    "stevearc/overseer.nvim",
    config = function()
      require("config.overseer").setup()
    end,
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      quickfile = { enabled = true },
      notifier = {
        enabled = true,
        timeout = 3000,
        margin = {
          top = 1,
        },
      },
      statuscolumn = { enabled = false },
      words = { enabled = false },
      styles = {
        notification = {
          zindex = 50,
          wo = {
            winblend = 0,
            wrap = true,
          },
        },
      },
    },
  },
}
