local borders = require("borders")
local icons = require("icons")
local colours = require("theme").colours

return {
  -- Icons for many things, requires a Nerd Font
  "kyazdani42/nvim-web-devicons",

  -- Highlight colour definitions (e.g. #555d60) and colour picker
  {
    "uga-rosa/ccc.nvim",
    opts = {
      highlighter = {
        auto_enable = true,
      },
    },
  },

  -- Improved UI for vim.ui.select and vim.ui.input (e.g. floating window for LSP rename)
  {
    "stevearc/dressing.nvim",
    config = function()
      require("dressing").setup({
        input = {
          insert_only = false,
          border = borders.hover,
          title_pos = "center",
          relative = "win",
        },
      })
    end,
  },

  "MunifTanjim/nui.nvim",

  -- Keymap hints popup
  {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup({
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
      })
    end,
  },

  -- Highlight active indent chunk
  {
    "shellRaining/hlchunk.nvim",
    config = function()
      require("hlchunk").setup({
        chunk = {
          enable = true,
          chars = {
            right_arrow = icons.triangle.tiny,
          },
          duration = 100,
          delay = 50,
          style = {
            { fg = colours.cursor_line },
            { fg = colours.light_red },
          },
        },
      })
    end,
  },
}
