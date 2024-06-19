local dap = require("dap")
local dap_ui = require("dapui")
local dap_python = require("dap-python")
-- Needs to be /virtual_text and not .virtual_text because of caching.
-- Modifying any property will not work if it's a dot (.) because the source
-- uses slash (/) and therefore has a different table.
local dap_virtual_text = require("nvim-dap-virtual-text")
local dap_mappings = require("mappings.dap")
local icons = require("icons")

local M = {}

function M.setup()
  dap_ui.setup({
    icons = icons.fold,
    layouts = {
      {
        elements = {
          { id = "scopes", size = 0.50 },
          { id = "watches", size = 0.10 },
          { id = "breakpoints", size = 0.20 },
          { id = "stacks", size = 0.20 },
        },
        size = 50,
        position = "left",
      },
      {
        elements = {
          "repl",
        },
        size = 20,
        position = "bottom",
      },
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

  vim.fn.sign_define(
    "DapBreakpoint",
    { text = icons.pad_left(icons.dot, 1), texthl = "DiagnosticSignError", numhl = "DiagnosticSignError" }
  )
  vim.fn.sign_define(
    "DapBreakpointCondition",
    { text = icons.pad_left(icons.question, 1), texthl = "DiagnosticSignError", numhl = "DiagnosticSignError" }
  )
  vim.fn.sign_define(
    "DapBreakpointRejected",
    { text = icons.pad_left(icons.lightning, 1), texthl = "DiagnosticSignError", numhl = "DiagnosticSignError" }
  )
  vim.fn.sign_define(
    "DapLogPoint",
    { text = icons.pad_left(icons.mic, 1), texthl = "DiagnosticSignInfo", numhl = "DiagnosticSignInfo" }
  )
  vim.fn.sign_define(
    "DapStopped",
    { text = icons.pad_left(icons.arrow.thick, 1), texthl = "DiagnosticSignWarn", numhl = "DiagnosticSign" }
  )

  dap_virtual_text.setup({
    text_prefix = icons.pad(icons.triangle.tiny, 2, 1),
    error_prefix = icons.pad(icons.triangle.tiny, 2, 1),
    info_prefix = icons.pad(icons.triangle.tiny, 2, 1),

    -- Show the virtualt text at the end of the line, because inline is way too big for
    -- larger values, such as lists or structs.
    virt_text_pos = "eol"
  })

  dap_mappings.enable_mappings()
end

return M
