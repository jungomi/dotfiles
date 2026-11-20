local nmap = require("utils.map").nmap
local xmap = require("utils.map").xmap

-- Align text
require("utils.align").setup({
  keys = {
    start = "sl",
  },
})

-- Markdown Table of Contents
local toc_utils = require("utils.toc")
toc_utils.setup()
nmap("<leader>mt", toc_utils.insert, { desc = "Markdown » Table of Contents" })

-- Markdown Tables
local table_utils = require("utils.table")
table_utils.setup()
nmap("st", table_utils.format, { desc = "Table » Format" })
xmap("st", table_utils.format, { desc = "Table » Format (visual)" })

-- Sudo write
local sudo_utils = require("utils.sudo")
sudo_utils.setup()
nmap("<leader>sw", sudo_utils.write, { desc = "File » Save with sudo" })
