local map_utils = require("utils.map")
local nmap = map_utils.nmap
local imap = map_utils.imap

local M = {}

_G.lsp_toggle = function()
  if next(vim.lsp.get_active_clients()) == nil then
    -- No LSP is running therefore try to start one.
    vim.api.nvim_command("LspStart")
  else
    vim.api.nvim_command("LspStop")
  end
end

function M.enable_mappings()
  -- Go to definition
  nmap("<leader>ld", vim.lsp.buf.definition, { desc = "LSP » Go to definition" })
  nmap("<leader>lf", function()
    vim.lsp.buf.format({ async = true })
  end, { desc = "LSP » Format" })
  -- Highlight references
  nmap("<leader>lh", vim.lsp.buf.document_highlight, { desc = "LSP » Highlight references" })
  nmap("<leader>lr", vim.lsp.buf.rename, { desc = "LSP » Rename" })
  -- Show type info of the word under the cursor
  nmap("<leader>lt", vim.lsp.buf.hover, { desc = "LSP » Hover info" })
  nmap("<leader>ls", vim.lsp.buf.signature_help, { desc = "LSP » Signature" })
  imap("<C-s>", vim.lsp.buf.signature_help, { desc = "LSP » Signature" })
  nmap("<leader>la", vim.lsp.buf.code_action, { desc = "LSP » Code actions" })
  -- Diagnostic navigation
  nmap("]d", function()
    vim.diagnostic.goto_next({ float = { border = "rounded" } })
  end, { desc = "LSP » Jump to next diagnostic" })
  nmap("[d", function()
    vim.diagnostic.goto_prev({ float = { border = "rounded" } })
  end, { desc = "LSP » Jump to previous diagnostic" })
  -- Diagnostics list similar to quickfix but better
  nmap("<leader>lq", "<Cmd>TroubleToggle document_diagnostics<CR>", { desc = "Trouble » Document diagnostics" })
end

return M
