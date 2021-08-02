local dap = require("dap")

local M = {}

function M.set_conditional_breakpoint(condition)
  -- Ask user to input a condition if none was given
  if not condition then
    condition = vim.trim(vim.fn.input("Condition: "))
  end
  -- Do not set the breakpoint if the condition is empty
  if condition == "" then
    return
  end
  dap.set_breakpoint(condition)
end

function M.set_hit_count_breakpoint(count)
  -- Ask user to input the hit count if none was given
  if count then
    -- Ensure that it's a string, because the hit count is more than a number
    -- for example >2 would stop for every step after hitting it twice.
    -- For convenience, so that the function can be called with just a number.
    count = tostring(count)
  else
    count = vim.trim(vim.fn.input("Hit Count: "))
  end
  -- Do not set the breakpoint if the given count is empty
  if count == "" then
    return
  end
  dap.set_breakpoint(nil, count)
end

function M.set_log_point(message)
  -- Ask user to input a message if none was given
  if not message then
    message = vim.trim(vim.fn.input("Log Message: "))
  end
  -- Do not set the log point if the message is empty
  if message == "" then
    return
  end
  dap.set_breakpoint(nil, nil, message)
end

return M
