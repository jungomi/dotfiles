local treesitter = require("nvim-treesitter")
local treesitter_objects = require("nvim-treesitter-textobjects")
local ts_comment = require("ts_context_commentstring")
local neogen = require("neogen")
local treesitter_mappings = require("mappings.treesitter")
local autocmd_utils = require("utils.autocmd")

local M = {
  -- TreeSitter highlighting isn't great for these,
  -- use regular syntax highlighting instead.
  -- Markdown is disabled because it has some terrible conceals (e.g. the code fences),
  -- which interferes with markview.
  disable_highlight = { "rust", "gitcommit", "markdown" },
  disable_indent = {},
}

-- A simple wrapper to create the autocmd based on the language.
-- Since the same treesitter language is used for multiple filetypes, it is not as simple as checking
-- if the filetype is in the disabled highlight/indent. Instead, the language defined in treesitter
-- are used and based on that it is programmatically enaled/disabled.
-- This just creates { highlight = true, indent = true } as a closure if they should be enabled.
local function create_autocmd_callback(lang)
  local opts = {
    highlight = not vim.tbl_contains(M.disable_highlight, lang),
    indent = not vim.tbl_contains(M.disable_indent, lang),
  }
  return function(ev)
    if opts.highlight then
      vim.treesitter.start(ev.buf)
    end
    if opts.indent then
      -- Enable indentation through tree-sitter. It caused a lot of issues the first time I tried,
      -- but that has been many years now, and it seems to be fine. And even fixes weird
      -- indentation in Python.
      vim.api.nvim_set_option_value("indentexpr", [[v:lua.require("nvim-treesitter").indentexpr()]], { buf = ev.buf })
    end
  end
end

-- Enable autocmds for all installed languages and each of their associated filetypes.
-- For example, the latex treesitter parser is used for tex and latex.
-- To avoid any runtime checks on the autocmds, there is one autocmd per filetype.
-- It might seem a little overkill, since that results in a lot of autocmds, but it still seems
-- like a cleaner solution.
function M.enable_autocmds()
  local installed_languages = treesitter.get_installed()
  local autocmds = vim
    .iter(installed_languages)
    :map(function(lang)
      local filetypes = vim.treesitter.language.get_filetypes(lang)
      return vim
        .iter(filetypes)
        :map(function(ft)
          return {
            event = "FileType",
            pattern = ft,
            callback = create_autocmd_callback(lang),
            desc = string.format("Treesitter enable highlight and indentation for %s (lang=%s)", ft, lang),
          }
        end)
        :totable()
    end)
    :flatten(1)
    :totable()
  autocmd_utils.create_augroups({
    config_treesitter = autocmds,
  })
end

function M.setup()
  vim.schedule(function()
    treesitter.install("all"):wait()
    -- Need to enable autocmds for the newly installed languages.
    M.enable_autocmds()
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

  M.enable_autocmds()
end

return M
