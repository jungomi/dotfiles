local dap = require("dap")
local dap_ui = require("dapui")
local dap_python = require("dap-python")
-- Needs to be /virtual_text and not .virtual_text because of caching.
-- Modifying any property will not work if it's a dot (.) because the source
-- uses slash (/) and therefore has a different table.
local dap_virtual_text = require("nvim-dap-virtual-text")
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
      size = 50,
    },
  })
  dap_python.setup()

  -- Automatically open and close DAP UI when the debugger is started/exited
  dap.listeners.after.event_initialized["dapui_config"] = function()
    dap_ui.open()
  end
  dap.listeners.before.event_terminated["dapui_config"] = function()
    dap_ui.close()
  end
  dap.listeners.before.event_exited["dapui_config"] = function()
    dap_ui.close()
  end

  vim.fn.sign_define("DapBreakpoint", { text = " ", texthl = "DiagnosticSignError", numhl = "DiagnosticSignError" })
  vim.fn.sign_define(
    "DapBreakpointCondition",
    { text = " ", texthl = "DiagnosticSignError", numhl = "DiagnosticSignError" }
  )
  vim.fn.sign_define(
    "DapBreakpointRejected",
    { text = " ", texthl = "DiagnosticSignError", numhl = "DiagnosticSignError" }
  )
  vim.fn.sign_define("DapLogPoint", { text = " ", texthl = "DiagnosticSignInfo", numhl = "DiagnosticSignInfo" })
  vim.fn.sign_define("DapStopped", { text = " ", texthl = "DiagnosticSignWarn", numhl = "DiagnosticSign" })

  dap_virtual_text.setup({
    text_prefix = "  ‣ ",
    error_prefix = "  ‣ ",
    info_prefix = "  ‣ ",
  })

  dap_mappings.enable_mappings()
end

return M
