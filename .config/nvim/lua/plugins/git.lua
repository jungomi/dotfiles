return {
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "esmuellert/codediff.nvim",
    },
  },
  -- VSCode style diffs (char wise)
  -- Also comes with a merge tool similar to VSCode
  {
    "esmuellert/codediff.nvim",
    opts = {
      highlights = {
        line_delete = "MarkviewDiffDelete",
      },
      explorer = {
        view_mode = "tree",
        indent_markers = false,
        icons = {
          folder_closed = " ",
          folder_open = " ",
        }
      },
      diff = {
        -- Need ours to be on the left, don't know why VSCode flipped it.
        -- This currently causes issues with the keymaps, so will keep the default for now.
        conflict_ours_position = "left",
        -- Height percent (not num lines) if the result is at at the bottom
        conflict_result_height = 50,
      },
      keymaps = {
        view = {
          quit = "gq",
        },
        conflict = {
          -- All these keymaps are flipped, as it does not choose the buffer when having "ours" on the left.
          -- e.g. `accept_incoming` is really `accept_left`.
          accept_incoming = "<leader>co",
          accept_current = "<leader>ct",
          accept_all_incoming = "<leader>cO",
          accept_all_current = "<leader>cT",
          diffget_incoming = "<leader>co",
          diffget_current = "<leader>ct",
        }
      }
    }
  },
  {
    "lewis6991/gitsigns.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("config.git").setup()
    end,
  },
}
