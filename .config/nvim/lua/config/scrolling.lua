local neoscroll = require("neoscroll")
local neoscroll_map = require("neoscroll.config").set_mappings

local M = {}

function M.setup()
  neoscroll.setup({
    -- Disable default mappings
    mappings = {},
    easing_function = "cubic",
  })
  neoscroll_map({
    ["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", "200" } },
    ["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", "200" } },
    ["<C-b>"] = { "scroll", { "-vim.api.nvim_win_get_height(0)", "true", "350" } },
    ["<C-f>"] = { "scroll", { "vim.api.nvim_win_get_height(0)", "true", "350" } },
    ["zt"] = { "zt", { "200" } },
    ["zz"] = { "zz", { "200" } },
    ["zb"] = { "zb", { "200" } },
  })
end

return M
