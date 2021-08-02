local map_utils = require("utils.map")
local nmap = map_utils.nmap

local M = {}

function M.enable_mappings()
  -- Continue or start debugger if it's not running already
  nmap("<leader>dc", [[<Cmd>lua require("dap").continue()<CR>]])
  -- Breakpoint
  nmap("<leader>db", [[<Cmd>lua require("dap").toggle_breakpoint()<CR>]])
  -- Step
  nmap("<leader>ds", [[<Cmd>lua require("dap").step_over()<CR>]])
  -- Into
  nmap("<leader>di", [[<Cmd>lua require("dap").step_into()<CR>]])
  -- Out
  nmap("<leader>do", [[<Cmd>lua require("dap").step_out()<CR>]])
  -- Continue to the cursor
  nmap("<leader>dh", [[<Cmd>lua require("dap").run_to_cursor()<CR>]])
  -- Log point (like a breakpoint but log a message when that point is reached)
  nmap("<leader>dl", [[<Cmd>lua require("utils.dap").set_log_point()<CR>]])
  -- Breakpoint with hit count (breaks after hitting n times)
  nmap("<leader>dt", [[<Cmd>lua require("utils.dap").set_hit_count_breakpoint()<CR>]])
  -- Conditional breakpoint
  nmap("<leader>dy", [[<Cmd>lua require("utils.dap").set_conditional_breakpoint()<CR>]])
end

return M
