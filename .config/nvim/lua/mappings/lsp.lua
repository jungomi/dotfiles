local conform = require("conform")
local luasnip = require("luasnip")
local map_utils = require("utils.map")
local ts_utils = require("utils.treesitter")
local nmap = map_utils.nmap
local imap = map_utils.imap
local smap = map_utils.smap

local M = {}

local function toggle_virtual_lines()
  local cfg = vim.diagnostic.config()
  if cfg.virtual_text then
    vim.diagnostic.config({ virtual_text = false, virtual_lines = cfg.config_when_enabled.virtual_lines })
  else
    vim.diagnostic.config({ virtual_text = cfg.config_when_enabled.virtual_text, virtual_lines = false })
  end
end

-- Toggle the inlay hints, globally if no buffer number is given.
local function toggle_inlay_hints(buf)
  local opts = { bufnr = buf } or nil
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(opts), opts)
end

-- <C-h>
local function snip_prev()
  if luasnip.jumpable(-1) then
    luasnip.jump(-1)
  else
    ts_utils.jump_start_of_node()
  end
end

-- <C-l>
local function snip_next()
  if luasnip.expand_or_jumpable() then
    luasnip.expand_or_jump()
  else
    ts_utils.jump_end_of_node()
  end
end

function M.enable_mappings()
  -- Go to definition
  nmap("<leader>ld", vim.lsp.buf.definition, { desc = "LSP » Go to definition" })
  nmap("<leader>lf", function()
    -- Conform will format it just like the LSP and fallback to the LSP if
    -- no formatter was configured for the given filetype.
    conform.format({ lsp_fallback = true, async = true })
  end, { desc = "LSP » Format" })
  -- Highlight references
  nmap("<leader>lh", vim.lsp.buf.document_highlight, { desc = "LSP » Highlight references" })
  nmap("<leader>lr", vim.lsp.buf.rename, { desc = "LSP » Rename" })
  -- Show type info of the word under the cursor
  nmap("<leader>lt", vim.lsp.buf.hover, { desc = "LSP » Hover info" })
  nmap("<leader>ls", vim.lsp.buf.signature_help, { desc = "LSP » Signature" })
  imap("<C-s>", vim.lsp.buf.signature_help, { desc = "LSP » Signature" })
  nmap("<leader>la", vim.lsp.buf.code_action, { desc = "LSP » Code actions" })
  nmap("<leader>lv", toggle_virtual_lines, { desc = "LSP » Toggle Virtual Lines" })
  nmap("<leader>li", toggle_inlay_hints, { desc = "LSP » Toggle Inlay Hints" })
  -- Diagnostic navigation
  nmap("]d", function()
    vim.diagnostic.goto_next({ float = { border = "rounded" } })
  end, { desc = "LSP » Jump to next diagnostic" })
  nmap("[d", function()
    vim.diagnostic.goto_prev({ float = { border = "rounded" } })
  end, { desc = "LSP » Jump to previous diagnostic" })
  -- Diagnostics list similar to quickfix but better
  nmap("<leader>lq", "<Cmd>TroubleToggle document_diagnostics<CR>", { desc = "Trouble » Document diagnostics" })
  -- Glance
  nmap("<leader>lgd", "<CMD>Glance definitions<CR>", { desc = "LSP » Glance » Definitions" })
  nmap("<leader>lgr", "<CMD>Glance references<CR>", { desc = "LSP » Glance » References" })
  nmap("<leader>lgt", "<CMD>Glance type_definitions<CR>", { desc = "LSP » Glance » Type Definitions" })
  nmap("<leader>lgi", "<CMD>Glance implementations<CR>", { desc = "LSP » Glance » Implementations" })
  -- Snippets
  imap("<C-h>", snip_prev, { desc = "Snippet » Previous" })
  smap("<C-h>", snip_prev, { desc = "Snippet » Previous" })
  imap("<C-l>", snip_next, { desc = "Snippet » Next" })
  smap("<C-l>", snip_next, { desc = "Snippet » Next" })
end

return M
