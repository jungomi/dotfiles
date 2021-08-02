local dap_ui = require("dapui")
local dap_python = require("dap-python")
local dap_mappings = require("mappings.dap")

local M = {}

function M.setup()
  dap_ui.setup({
    icons = { expanded = "", collapsed = "" },
    sidebar = {
      elements = {
        {
          id = "scopes",
          size = 0.50,
        },
        { id = "watches", size = 0.10 },
        { id = "breakpoints", size = 0.20 },
        { id = "stacks", size = 0.20 },
      },
      width = 50,
    },
  })
  dap_python.setup()

  vim.fn.sign_define(
    "DapBreakpoint",
    { text = " ", texthl = "LspDiagnosticsSignError", numhl = "LspDiagnosticsSignError" }
  )
  vim.fn.sign_define(
    "DapBreakpointRejected",
    { text = " ", texthl = "LspDiagnosticsSignError", numhl = "LspDiagnosticsSignError" }
  )
  vim.fn.sign_define(
    "DapLogPoint",
    { text = " ", texthl = "LspDiagnosticsSignInformation", numhl = "LspDiagnosticsSignInformation" }
  )
  vim.fn.sign_define(
    "DapStopped",
    { text = " ", texthl = "LspDiagnosticsSignWarning", numhl = "LspDiagnosticsSignWarning" }
  )

  vim.g.dap_virtual_text = true

  dap_mappings.enable_mappings()
end

return M
