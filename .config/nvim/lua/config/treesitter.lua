local M = {}

local ts_configs = require("nvim-treesitter.configs")
local neogen = require("neogen")
local treesitter_mappings = require("mappings.treesitter")

function M.setup()
  ts_configs.setup({
    ensure_installed = "all",
    highlight = {
      enable = true,
      -- TreeSitter highlighting isn't great for these,
      -- use regular syntax highlighting instead.
      -- For markdown there is markdown_inline, which is superior.
      disable = { "rust", "gitcommit", "markdown" },
    },
    -- Indentation doesn't work well yet
    indent = {
      enable = false,
    },
    -- Setting correct comments for nested languages
    context_commentstring = {
      enable = true,
      -- Don't do it all the time, only when using the commenting plugin
      enable_autocmd = false,
    },
    playground = {
      enable = true,
    },
    textobjects = {
      move = {
        enable = true,
        goto_next_start = {
          ["]c"] = "@class.outer",
          ["]f"] = "@function.outer",
        },
        goto_next_end = {
          ["]C"] = "@class.outer",
          ["]F"] = "@function.outer",
        },
        goto_previous_start = {
          ["[c"] = "@class.outer",
          ["[f"] = "@function.outer",
        },
        goto_previous_end = {
          ["[C"] = "@class.outer",
          ["[F"] = "@function.outer",
        },
      },
      select = {
        enable = true,
        -- Automatically jump forward to textobj if not already on it.
        lookahead = true,
        keymaps = {
          ["ic"] = "@class.outer",
          ["ac"] = "@class.outer",
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ["]a"] = "@parameter.inner",
        },
        swap_previous = {
          ["[a"] = "@parameter.inner",
        },
      },
    },
    textsubjects = {
      enable = true,
      prev_selection = "<C-i>",
      keymaps = {
        ["<C-o>"] = "textsubjects-smart",
      },
    },
  })

  neogen.setup({
    -- Don't go into insert mode after creating the docs
    input_after_comment = false,
  })

  treesitter_mappings.enable_mappings()
end

return M
