local map_utils = require("utils.map")
local nmap = map_utils.nmap
local xmap = map_utils.xmap

local M = {}

function M.enable_mappings()
  -- Custom mapping for updating the commentstring to trigger before commenting.
  -- Breaks <count>gc<motion> but the same can be achieved with gc<count><motion>,
  -- which I always did anyway. Worth it.
  nmap(
    "<Plug>(update_commentstring)",
    [[<Cmd>lua require("ts_context_commentstring.internal").update_commentstring()<CR>]]
  )
  xmap(
    "<Plug>(update_commentstring)",
    [[<Cmd>lua require("ts_context_commentstring.internal").update_commentstring()<CR>]]
  )

  nmap("gc", "<Plug>(update_commentstring)<Plug>kommentary_motion_default", { noremap = false })
  -- Comment current line
  nmap("gcc", "gcl", { noremap = false })
  -- Exit visual mode after commenting
  xmap("gc", "<Plug>(update_commentstring)<Plug>kommentary_visual_default<Esc>", { noremap = false })
end

return M
