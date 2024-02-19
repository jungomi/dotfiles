local substitute = require("substitute")
local exchange = require("substitute.exchange")
local map_utils = require("utils.map")
local nmap = map_utils.nmap
local xmap = map_utils.xmap

local M = {}

function M.enable_mappings()
  -- Substitute
  -- Essentially paste over the operator (does not overwrite yank register)
  nmap("sf", substitute.operator, { desc = "Substitute » Operator" })
  nmap("sff", substitute.line, { desc = "Substitute » Line" })
  xmap("sf", substitute.visual, { desc = "Substitute » Visual" })

  -- Exchange
  nmap("sx", exchange.operator, { desc = "Substitute » Exchange » Operator" })
  nmap("sxx", exchange.line, { desc = "Substitute » Exchange » Line" })
  nmap("sxc", exchange.cancel, { desc = "Substitute » Exchange » Cancel" })
  xmap("sx", exchange.visual, { desc = "Substitute » Exchange » Visual" })
end

return M
