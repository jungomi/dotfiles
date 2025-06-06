local map_utils = require("utils.map")
local nmap = map_utils.nmap

local M = {}

local function load_lazy_extensions()
  -- Import it here on demand instead of at the top to avoid import cycle.
  local llm_config = require("config.llm")
  llm_config.load_lazy_extensions()
  local names = vim
    .iter(llm_config.lazy_extensions)
    :map(function(name)
      return name
    end)
    :join(", ")
  vim.notify(string.format("Loaded extensions: %s", names))
end

function M.enable_mappings()
  nmap("<leader>cc", "<CMD>CodeCompanionChat<CR>", { desc = "Code Companion » Chat" })
  nmap("<leader>ci", "<CMD>CodeCompanion<CR>", { desc = "Code Companion » Inline" })
  nmap("<leader>ca", "<CMD>CodeCompanionActions<CR>", { desc = "Code Companion » Actions" })
  nmap("<leader>cm", load_lazy_extensions, { desc = "Code Companion » Load lazy extensions" })
end

return M
