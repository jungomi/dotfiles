local neoscroll = require("neoscroll")
local map_utils = require("utils.map")
local map = map_utils.map

local M = {
  -- By default, as a reference 10 lines should be scrolled in 120ms
  time = 120,
  time_half = 80,
  reference_lines = 10,
}

-- Get a normalised duration based on the desired speed.
-- This uses a reference time to scroll a certain number of lines.
-- Based on: https://github.com/karb94/neoscroll.nvim/issues/63#issuecomment-1477902635
function M.duration_from_lines(num, time)
  time = time or M.time
  local win_height = vim.api.nvim_win_get_height(0)
  num = num or win_height
  -- Num can be a percentage of the window
  if num % 1 ~= 0 then
    num = num * win_height
  end
  local lines_ratio = num / win_height
  local win_ratio = win_height / M.reference_lines
  local factor = win_ratio * lines_ratio
  local log_factor = 1 / math.log(1 / factor + 1, 2)
  return time * log_factor
end

function M.enable_mappings()
  map({ "n", "v" }, "<C-u>", function()
    neoscroll.ctrl_u({ duration = M.duration_from_lines(vim.wo.scroll, M.time_half) })
  end, {
    desc = "Scroll » Half Page Up",
  })
  map({ "n", "v" }, "<C-d>", function()
    neoscroll.ctrl_d({ duration = M.duration_from_lines(vim.wo.scroll, M.time_half) })
  end, {
    desc = "Scroll » Half Page Down",
  })
  map({ "n", "v" }, "<C-b>", function()
    neoscroll.ctrl_b({ duration = M.duration_from_lines() })
  end, {
    desc = "Scroll » Full Page Up",
  })
  map({ "n", "v" }, "<C-f>", function()
    neoscroll.ctrl_f({ duration = M.duration_from_lines() })
  end, {
    desc = "Scroll » Full Page Down",
  })

  map({ "n", "v" }, "zt", function()
    neoscroll.zt({ half_win_duration = M.duration_from_lines(vim.wo.scroll, M.time_half) })
  end, {
    desc = "Scroll » Current Line to Top",
  })
  map({ "n", "v" }, "zz", function()
    neoscroll.zz({ half_win_duration = M.duration_from_lines(vim.wo.scroll, M.time_half) })
  end, {
    desc = "Scroll » Current Line to Centre",
  })
  map({ "n", "v" }, "zb", function()
    neoscroll.zb({ half_win_duration = M.duration_from_lines(vim.wo.scroll, M.time_half) })
  end, {
    desc = "Scroll » Current Line to Bottom",
  })
end

return M
