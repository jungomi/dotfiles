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
  nmap("<leader>lr", "<Cmd>Lspsaga rename<CR>")
  nmap("<leader>lg", "<Cmd>lua vim.lsp.buf.hover()<CR>")
  -- Show type info of the word under the cursor
  nmap("<leader>lt", "<Cmd>Lspsaga hover_doc<CR>")
  nmap("<leader>ls", "<Cmd>lua vim.lsp.buf.signature_help()<CR>")
  imap("<C-s>", "<Cmd>lua vim.lsp.buf.signature_help()<CR>")
  nmap("<leader>la", "<Cmd>Lspsaga code_action<CR>")
  -- Diagnostic navigation
  nmap("]d", "<Cmd>Lspsaga diagnostic_jump_next<CR>")
  nmap("[d", "<Cmd>Lspsaga diagnostic_jump_prev<CR>")
  -- Diagnostics list similar to quickfix but better
  nmap("<leader>lq", "<Cmd>TroubleToggle lsp_document_diagnostics<CR>")
end

return M
