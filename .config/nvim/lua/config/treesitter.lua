local M = {}

local ts_configs = require("nvim-treesitter.configs")
local ts_spell = require("spellsitter")
local neogen = require("neogen")
local treesitter_mappings = require("mappings.treesitter")

function M.setup()
  ts_configs.setup({
    ensure_installed = "all",
    highlight = {
      enable = true,
      -- TreeSitter highlighting isn't great for these,
      -- use regular syntax highlighting instead.
      disable = { "rust", "gitcommit" },
    },
    -- Indentation doesn't work well yet
    indent = {
      enable = false,
    },
    incremental_selection = {
      enable = false,
      keymaps = {
        init_selection = "gnn",
        node_incremental = "grn",
        scope_incremental = "grc",
        node_decremental = "grm",
      },
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
  })

  ts_spell.setup({
    -- Spell check in these groups
    captures = { "comment", "string" },
  })

  neogen.setup({
    -- Don't go into insert mode after creating the docs
    input_after_comment = false,
  })

  treesitter_mappings.enable_mappings()
end

return M
