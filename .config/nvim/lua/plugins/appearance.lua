local borders = require("borders")

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
    dependencies = {
      -- Only show buffers that were used within a tab
      "tiagovla/scope.nvim",
      "kyazdani42/nvim-web-devicons",
    },
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
  {
    "dstein64/nvim-scrollview",
    config = function()
      require("config.scrollbar").setup()
    end,
  },
  -- Highlight colour definitions (e.g. #555d60) and colour picker
  {
    "uga-rosa/ccc.nvim",
    config = function()
      require("ccc").setup({
        highlighter = {
          auto_enable = true,
        },
      })
    end,
  },
  -- Improved UI for vim.ui.select and vim.ui.input (e.g. floating window for LSP rename)
  {
    "stevearc/dressing.nvim",
    config = function()
      require("dressing").setup({
        input = { insert_only = false, border = borders.hover, title_pos = "center", relative = "win" },
      })
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
  {
    "folke/which-key.nvim",
    opts = {
      delay = function(ctx)
        local delay = 500
        if ctx.plugin == "registers" or ctx.plugin == "marks" then
          -- This is a bit weird, because these are triggered instantly, and I think it is achieved
          -- by setting ctx.waited == delay, so if it's just added to it, the delay will be correct.
          return (ctx.waited or 0) + delay
        end
        return delay
      end,
      defer = function(ctx)
        return vim.list_contains({ "<C-V>", "V", "v" }, ctx.mode)
      end,
      plugins = {
        spelling = {
          enabled = true,
        },
      },
      win = {
        border = borders.default,
      },
    },
  },
  {
    "MeanderingProgrammer/markdown.nvim",
    name = "render-markdown",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      heading = {
        backgrounds = {},
      },
      code = {
        highlight = "CursorLine",
      },
      dash = {
        highlight = "Title",
      },
      pipe_table = {
        row = "Title",
      },
      link = {
        highlight = "Comment",
      },
    },
  },
}
