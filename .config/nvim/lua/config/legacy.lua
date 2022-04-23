-- All configuration for legacy plugins
local legacy_mappings = require("mappings.legacy")
local g = vim.g

local M = {}

function M.setup()
  -- Ignore editorconfig for fugitive buffers
  g.EditorConfig_exclude_patterns = { "fugitive://.*" }
  -- Keep formatoptions, because this adds wrapping automatically, which I only want for comments.
  -- Particularly in Python, it just breaks everything when automatically wrapping.
  g.EditorConfig_preserve_formatoptions = 1

  g.undotree_SetFocusWhenToggle = 1

  g.user_emmet_leader_key = "<C-e>"
  g.user_emmet_mode = "i"

  -- Markdown code blocks highlighting
  g.markdown_fenced_languages = {
    "html",
    "python",
    "py=python",
    "bash=sh",
    "ruby",
    "javascript",
    "js=javascript",
    "typescript",
    "ts=typescript",
    "lua",
    "sh",
    "css",
    "json",
    "vim",
    "ocaml",
    "rust",
    "go",
    "haskell",
  }

  -- Fzf window at bottom of current window
  g.fzf_layout = { window = { width = 1.0, height = 0.4, relative = true, yoffset = 1.0, border = "top" } }

  -- Set the snippets path to ~/.config/nvim/snippets
  g.vsnip_snippet_dir = vim.fn.stdpath("config") .. "/snippets"
  -- Reduce the delay for showing the choice menu
  g.vsnip_choice_delay = 100

  legacy_mappings.enable_mappings()
end

return M
