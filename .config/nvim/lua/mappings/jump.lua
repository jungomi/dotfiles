local flash = require("flash")
local map_utils = require("utils.map")
local nmap = map_utils.nmap
local omap = map_utils.omap
local vmap = map_utils.vmap

local M = {}

function M.enable_mappings()
  nmap("<leader>se", flash.jump, { desc = "Jump » Exact" })
  -- Fuzzy version of jumping
  nmap("<leader>sf", function()
    flash.jump({ search = { mode = "fuzzy" } })
  end, { desc = "Jump » Fuzzy" })
  nmap("<leader>st", flash.treesitter, { desc = "Jump » Treesitter (Select)" })
  vmap("<leader>st", flash.treesitter, { desc = "Jump » Treesitter (Select)" })

  omap("r", flash.remote, { desc = "Jump » Remote Execute" })
  omap("s", function()
    flash.jump({ search = { multi_window = false }, jump = { inclusive = true, pos = "end" } })
  end, { desc = "Jump » Operator Pending (Inclusive)" })
  omap("S", function()
    flash.jump({ search = { multi_window = false }, jump = { inclusive = false, pos = "start" } })
  end, { desc = "Jump » Operator Pending (Exclusive)" })
end

return M
