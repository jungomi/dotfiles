local map_utils = require("utils.map")
local nmap = map_utils.nmap
local imap = map_utils.imap

local M = {}

_G.lsp_toggle = function()
  if next(vim.lsp.buf_get_clients()) == nil then
    -- No LSP is running in the current buffer,
    -- therefore try to start one.
    vim.api.nvim_command("LspStart")
  else
    vim.api.nvim_command("LspStop")
  end
end

function M.enable_mappings()
  -- Go to definition
  nmap("<leader>ld", "<Cmd>lua vim.lsp.buf.definition()<CR>")
  nmap("<leader>lf", "<Cmd>lua vim.lsp.buf.formatting()<CR>")
  -- Highlight references
  nmap("<leader>lh", "<Cmd>lua vim.lsp.buf.document_highlight()<CR>")
  nmap("<leader>lr", "<Cmd>lua vim.lsp.buf.rename()<CR>")
  -- Show type info of the word under the cursor
  nmap("<leader>lt", "<Cmd>lua vim.lsp.buf.hover()<CR>")
  nmap("<leader>ls", "<Cmd>lua vim.lsp.buf.signature_help()<CR>")
  imap("<C-s>", "<Cmd>lua vim.lsp.buf.signature_help()<CR>")
  nmap("<leader>la", "<Cmd>lua vim.lsp.buf.code_action()<CR>")
  -- Diagnostic navigation
  nmap("]d", [[<Cmd>lua vim.diagnostic.goto_next({ float = { border = "rounded" }})<CR>]])
  nmap("[d", [[<Cmd>lua vim.diagnostic.goto_prev({ float = { border = "rounded" }})<CR>]])
  -- Diagnostics list similar to quickfix but better
  nmap("<leader>lq", "<Cmd>TroubleToggle lsp_document_diagnostics<CR>")
end

return M
