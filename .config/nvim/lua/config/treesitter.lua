local M = {}

local ts_configs = require("nvim-treesitter.configs")
local ts_spell = require("spellsitter")

function M.setup()
  ts_configs.setup {
    ensure_installed = "all",
    highlight = {
      enable = true,
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
  }

  ts_spell.setup {
    -- Spell check in these groups
    captures = {"comment", "string"},
  }
end

return M
