local autocmd_utils = require("utils.autocmd")

autocmd_utils.create_augroups({
  config_filetype = {
    -- Disable comment continuation when using 'o' or 'O'
    { "FileType", "*", "setlocal formatoptions-=o" },
    -- Activate spell checking for relevant files
    { "FileType", { "gitcommit", "markdown", "tex", "text" }, "setlocal spell" },
    -- Prevent some unwanted indenting like if the previous line ended with a comma
    { "FileType", { "gitcommit", "markdown", "tex", "text", "csv" }, "setlocal nocindent" },
    -- Disable colour column in quickfix window
    { "FileType", "qf", "setlocal colorcolumn=" },

    -- Tab settings
    { "FileType", "python", "setlocal shiftwidth=4 textwidth=88 softtabstop=4 expandtab" },
    { "FileType", "make", "setlocal tabstop=8 shiftwidth=8 softtabstop=8 noexpandtab" },
    { "FileType", "csv", "setlocal noexpandtab" },

    -- Trigger completion with Tab in DAP REPL (to make it feel like a REPL)
    { "FileType", "dap-repl", "inoremap <buffer> <Tab> <C-x><C-o>" },
  },
  config_buffer = {
    -- Resize panes when the window is resized
    { "VimResized", "*", "wincmd =" },
    -- Highlight text that has been copied
    { "TextYankPost", "*", [[silent! lua vim.highlight.on_yank {higroup = "Yank", timeout = 250}]] },
    -- Clear highlighted references when moving the cursor
    { "CursorMoved", "*", [[lua vim.lsp.buf.clear_references()]] },
    -- Close location list when the associated buffer is closed
    { "QuitPre", "*", "if empty(&buftype) | lclose | endif" },
    { "BufWritePre", "*", [[lua require("utils.file").mkdir_on_save()]] },
    -- Refresh colours after any text change, it should do that on its own
    -- but after non-insert mode edits, such as undo, it doesn't.
    { "TextChanged", "*", "ColorizerAttachToBuffer" },
  },
})
