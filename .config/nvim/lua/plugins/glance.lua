local nmap = require("utils.map").nmap

local M = {
  -- Preview LSP references / definitions etc in a neat floating window
  "dnlhc/glance.nvim",
}

function M.config()
  local glance = require("glance")

  glance.setup({
    height = 24,
    border = {
      enable = true,
    },
    mappings = {
      list = {
        ["<C-h>"] = glance.actions.enter_win("preview"),
        -- It might look weird to have the mapping to select itself, but that's just to overwrite the window
        -- switching as that would go outside of the glance window into a regular one.
        ["<C-l>"] = glance.actions.enter_win("list"),
        ["gq"] = glance.actions.close,
      },
      preview = {
        ["<C-h>"] = glance.actions.enter_win("preview"),
        ["<C-l>"] = glance.actions.enter_win("list"),
        ["gq"] = glance.actions.close,
      },
    },
  })
end

function M.keys()
  nmap("<leader>lgd", "<CMD>Glance definitions<CR>", { desc = "LSP » Glance » Definitions" })
  nmap("<leader>lgr", "<CMD>Glance references<CR>", { desc = "LSP » Glance » References" })
  nmap("<leader>lgt", "<CMD>Glance type_definitions<CR>", { desc = "LSP » Glance » Type Definitions" })
  nmap("<leader>lgi", "<CMD>Glance implementations<CR>", { desc = "LSP » Glance » Implementations" })
end

return M
