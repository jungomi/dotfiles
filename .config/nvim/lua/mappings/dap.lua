local dap = require("dap")
local dap_utils = require("utils.dap")
local map_utils = require("utils.map")
local nmap = map_utils.nmap

local M = {}

function M.enable_mappings()
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
end

return M
