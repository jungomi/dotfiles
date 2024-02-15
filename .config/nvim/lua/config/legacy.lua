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

  -- Why that is a thing is beyond me.
  -- Not only is it enabled by default, it somehow is installed without any plugin.
  -- First of all, I hate autoformat on save, but to make matters worse, it will
  -- also open a quickfix window with an error and at some point even that failed miserably.
  -- This is truly one of the worst defaults.
  g.zig_fmt_autosave = 0
  legacy_mappings.enable_mappings()
end

return M
