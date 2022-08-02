local dap = require("dap")

local M = {}

function M.set_conditional_breakpoint(condition)
  if condition then
    dap.set_breakpoint(condition)
  else
    -- Ask user to input a condition if none was given
    vim.ui.input({ prompt = "Condition" }, function(input)
      input = vim.trim(input or "")
      -- Do not set the breakpoint if the condition is empty
      if input ~= "" then
        dap.set_breakpoint(input)
      end
    end)
  end
end

function M.set_hit_count_breakpoint(count)
  if count then
    -- Ensure that it's a string, because the hit count is more than a number
    -- for example >2 would stop for every step after hitting it twice.
    -- For convenience, so that the function can be called with just a number.
    count = tostring(count)
    dap.set_breakpoint(nil, count)
  else
    -- Ask user to input the hit count if none was given
    vim.ui.input({ prompt = "Hit Count" }, function(input)
      input = vim.trim(input or "")
      -- Do not set the breakpoint if the given count is empty
      if input ~= "" then
        dap.set_breakpoint(nil, input)
      end
    end)
  end
end

function M.set_log_point(message)
  if message then
    dap.set_breakpoint(nil, nil, message)
  else
    -- Ask user to input a message if none was given
    vim.ui.input({ prompt = "Log Message" }, function(input)
      input = vim.trim(input or "")
      -- Do not set the log point if the message is empty
      if input ~= "" then
        dap.set_breakpoint(nil, nil, input)
      end
    end)
  end
end

return M
