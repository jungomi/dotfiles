local fzf = require("fzf-lua")
local map_utils = require("utils.map")
local nmap = map_utils.nmap

local M = {}

function M.enable_mappings()
  nmap("<leader>ff", fzf.files, { desc = "Fuzzy » Files" })
  -- Config files
  nmap("<leader>fv", function()
    fzf.files({ cwd = vim.fn.stdpath("config") })
  end, { desc = "Fuzzy » Configs" })
  -- History of recently opened files
  nmap("<leader>fh", fzf.oldfiles, { desc = "Fuzzy » History" })
  nmap("<leader>fg", fzf.git_files, { desc = "Fuzzy » Git files" })
  -- Git status
  nmap("<leader>fs", fzf.git_status, { desc = "Fuzzy » Git status" })
  nmap("<leader>fb", fzf.buffers, { desc = "Fuzzy » Buffers" })
  nmap("<leader>fl", fzf.blines, { desc = "Fuzzy » Lines" })
  nmap("<leader>fm", fzf.marks, { desc = "Fuzzy » Marks" })
  nmap("<leader>fq", fzf.diagnostics_document, { desc = "Fuzzy » Diagnostics" })
  nmap("<leader>fd", fzf.lsp_definitions, { desc = "Fuzzy » Definitions" })
  nmap("<leader>fr", fzf.lsp_references, { desc = "Fuzzy » References" })
  -- These incoming/outgoing calls are rarely supported, so far I've only seen it for Rust and basedpyright, but it's
  -- pretty nifty.
  nmap("<leader>fi", fzf.lsp_incoming_calls, { desc = "Fuzzy » Incoming Calls" })
  nmap("<leader>fo", fzf.lsp_outgoing_calls, { desc = "Fuzzy » Outgoing Calls" })
  -- `r` is already taken, and this isn't used much anyway, so `y` not.
  nmap("<leader>fy", fzf.grep, { desc = "Fuzzy » Ripgrep" })
  -- Resume the last picker wherever it was left off.
  -- That is probably one of the nicest features from Telescope that is now supported by fzf-lua.
  -- There are so many times were I want to do the exact same, but choose a different result,
  -- with this it's even better, because it also remembers the state, so the typed filters
  -- don't need to be repeated, super underrated feature.
  nmap("<leader>fa", fzf.resume, { desc = "Fuzzy » Resume" })
end

return M
