return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("config.treesitter").setup()
    end,
    dependencies = {
      "nvim-treesitter/playground",
      "nvim-treesitter/nvim-treesitter-textobjects",
      "JoosepAlviste/nvim-ts-context-commentstring",
      -- Generate DocStrings
      "danymat/neogen",
    },
  },
  {
    -- Automatically convert regular quotes to interpolated versions (including f-strings for Python)
    "axelvc/template-string.nvim",
    opts = {
      -- Convert to regular quotes when there is no interpolation
      remove_template_string = true,
      restore_quotes = {
        -- Use double quotes for regular quotes
        normal = [["]],
      },
    },
  },
}
