local icons = require("icons")
local nmap = require("utils.map").nmap

local dap_spec = {
  "mfussenegger/nvim-dap",
  config = function()
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
  end,
  keys = function()
    local dap = require("dap")
    local dap_utils = require("utils.dap")

    -- Continue or start debugger if it's not running already
    nmap("<leader>dc", dap.continue, { desc = "Debugger » Continue" })
    -- Quit the debugger (terminates the session and disconnects)
    nmap("<leader>dq", dap.terminate, { desc = "Debugger » Quit" })
    -- Breakpoint
    nmap("<leader>db", dap.toggle_breakpoint, { desc = "Debugger » Breakpoint" })
    -- Step
    nmap("<leader>ds", dap.step_over, { desc = "Debugger » Step over" })
    -- Into
    nmap("<leader>di", dap.step_into, { desc = "Debugger » Step into" })
    -- Out
    nmap("<leader>do", dap.step_out, { desc = "Debugger » Step out" })
    -- Continue to the cursor
    nmap("<leader>dh", dap.run_to_cursor, { desc = "Debugger » Continue to cursor" })
    -- Log point (like a breakpoint but log a message when that point is reached)
    nmap("<leader>dl", dap_utils.set_log_point, { desc = "Debugger » Log point" })
    -- Breakpoint with hit count (breaks after hitting n times)
    nmap("<leader>dt", dap_utils.set_hit_count_breakpoint, { desc = "Debugger » Hit count breakpoint" })
    -- Conditional breakpoint
    nmap("<leader>dy", dap_utils.set_conditional_breakpoint, { desc = "Debugger » Conditional breakpoint" })
  end,
}

local dap_ui_spec = {
  "rcarriga/nvim-dap-ui",
  config = function()
    local dap = require("dap")
    local dap_ui = require("dapui")

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
  end,
}

local dap_virtual_text_spec = {
  -- Needs to be /virtual_text and not .virtual_text because of caching.
  -- Modifying any property will not work if it's a dot (.) because the source
  -- uses slash (/) and therefore has a different table.
  "theHamsta/nvim-dap-virtual-text",
  config = function()
    require("nvim-dap-virtual-text").setup({
      text_prefix = icons.pad(icons.triangle.tiny, 2, 1),
      error_prefix = icons.pad(icons.triangle.tiny, 2, 1),
      info_prefix = icons.pad(icons.triangle.tiny, 2, 1),

      -- Show the virtualt text at the end of the line, because inline is way too big for
      -- larger values, such as lists or structs.
      virt_text_pos = "eol",
    })
  end,
}

return {
  "nvim-neotest/nvim-nio",
  dap_spec,
  dap_ui_spec,
  dap_virtual_text_spec,
  {
    "mfussenegger/nvim-dap-python",
    config = function()
      require("dap-python").setup()
    end,
  },
}
