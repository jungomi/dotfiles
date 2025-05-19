-- lightbulb might not be installed yet, so make sure it doesn't fail
local _, lightbulb = pcall(require, "nvim-lightbulb")
local autocmd_utils = require("utils.autocmd")
local file_utils = require("utils.file")

autocmd_utils.create_augroups({
  config_filetype = {
    -- Disable comment continuation when using 'o' or 'O'
    {
      event = "FileType",
      pattern = "*",
      command = "setlocal formatoptions-=o",
      desc = "Disable comment continuation when using `o` or `O`",
    },
    -- Activate spell checking for relevant files
    {
      event = "FileType",
      pattern = { "gitcommit", "markdown", "tex", "text" },
      command = "setlocal spell",
      desc = "Enable spell check for relevant files",
    },
    -- Prevent some unwanted indenting like if the previous line ended with a comma
    {
      event = "FileType",
      pattern = { "gitcommit", "markdown", "tex", "text", "csv" },
      command = "setlocal nocindent",
      desc = "Prevent unwanted identing in certain files",
    },
    -- Disable colour column in quickfix window
    {
      event = "FileType",
      pattern = "qf",
      command = "setlocal colorcolumn=",
      desc = "Disable colour column in quickfix",
    },

    -- Tab settings
    {
      event = "FileType",
      pattern = "python",
      command = "setlocal shiftwidth=4 textwidth=88 softtabstop=4 expandtab",
      desc = "Tab settings for Python",
    },
    {
      event = "FileType",
      pattern = "make",
      command = "setlocal tabstop=8 shiftwidth=8 softtabstop=8 noexpandtab",
      desc = "Tab settings for Makefile",
    },
    {
      event = "FileType",
      pattern = "csv",
      command = "setlocal noexpandtab",
      desc = "Tab for CSV",
    },
    -- BufReadPost and BufNewFile instead of FileType because otherwise it gets overwritten from somehwere,
    -- don't know why, just again something terrible about the built-in zig support.
    {
      event = { "BufReadPost", "BufNewFile" },
      pattern = "*.zig",
      command = "setlocal shiftwidth=4 softtabstop=4",
      desc = "Tab settings for Zig",
    },
    {
      event = "FileType",
      pattern = "codecompanion",
      callback = function()
        vim.treesitter.start(0, "markdown")
      end,
      desc = "Enable Markdown syntax highlighting in Coecompanion chat buffers",
    },
    -- Trigger completion with Tab in DAP REPL (to make it feel like a REPL)
    {
      event = "FileType",
      pattern = "dap-repl",
      command = "inoremap <buffer> <Tab> <C-x><C-o>",
      desc = "DAP REPL - Trigger completion with Tab",
    },
  },
  config_buffer = {
    -- Resize panes when the window is resized
    {
      event = "VimResized",
      pattern = "*",
      command = "wincmd =",
      desc = "Resize windows when Vim is resized",
    },
    -- Highlight text that has been copied
    {
      event = "TextYankPost",
      pattern = "*",
      callback = function()
        vim.hl.on_yank({ higroup = "Yank", timeout = 250 })
      end,
      desc = "Highlight yanked text",
    },
    -- Clear highlighted references when moving the cursor
    {
      event = "CursorMoved",
      pattern = "*",
      callback = vim.lsp.buf.clear_references,
      desc = "Clear highlighted LSP references when cursor is moved",
    },
    -- Close location list when the associated buffer is closed
    {
      event = "QuitPre",
      pattern = "*",
      command = "if empty(&buftype) | lclose | endif",
      desc = "Close location list when associated buffer is closed",
    },
    {
      event = "BufWritePre",
      pattern = "*",
      callback = file_utils.mkdir_on_save,
      desc = "Ensure directories exist when saving a file",
    },
    -- Update lightbulb sign
    {
      event = "CursorHold",
      pattern = "*",
      -- No-op if lightbulb has not been installed yet
      callback = lightbulb and lightbulb.update_lightbulb or function() end,
      desc = "Show a lightbulb sign if a code action is available for the current line",
    },
  },
})
