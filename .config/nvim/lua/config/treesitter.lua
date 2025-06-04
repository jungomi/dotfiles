local treesitter = require("nvim-treesitter")
local treesitter_objects = require("nvim-treesitter-textobjects")
local ts_comment = require("ts_context_commentstring")
local neogen = require("neogen")
local treesitter_mappings = require("mappings.treesitter")
local autocmd_utils = require("utils.autocmd")

local M = {
  -- TreeSitter highlighting isn't great for these,
  -- use regular syntax highlighting instead.
  -- For markdown there is markdown_inline, which is superior.
  disable_highlight = { "rust", "gitcommit" },
  disable_indent = {},
}

function M.setup()
  vim.schedule(function()
    treesitter.install("all")
  end)

  treesitter_objects.setup({
    select = {
      -- Automatically jump to the next textobject if not already on it.
      lookahead = true,
    },
  })

  -- Setting correct comments for nested languages
  ts_comment.setup({
    -- Don't do it all the time, only when using the commenting plugin
    enable_autocmd = false,
  })

  neogen.setup({
    -- Don't go into insert mode after creating the docs
    input_after_comment = false,
  })

  treesitter_mappings.enable_mappings()

  autocmd_utils.create_augroups({
    config_treesitter = {
      {
        event = "FileType",
        pattern = "*",
        callback = function(ev)
          local installed_languages = treesitter.get_installed()
          if vim.tbl_contains(installed_languages, ev.match) then
            if not vim.tbl_contains(M.disable_highlight, ev.match) then
              vim.treesitter.start(ev.buf)
            end
            if not vim.tbl_contains(M.disable_indent, ev.match) then
              -- Enable indentation through tree-sitter. It caused a lot of issues the first time I tried,
              -- but that has been many years now, and it seems to be fine. And even fixes weird
              -- indentation in Python.
              vim.api.nvim_set_option_value(
                "indentexpr",
                "v:lua.require('nvim-treesitter').indentexpr()",
                { buf = ev.buf }
              )
            end
          end
        end,
        desc = "Treesitter enable highlight and indentation for installed languages",
      },
    },
  })
end

return M
