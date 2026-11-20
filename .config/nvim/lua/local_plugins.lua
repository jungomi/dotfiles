local nmap = require("utils.map").nmap
local xmap = require("utils.map").xmap

-- Align text
require("utils.align").setup({
  keys = {
    start = "sl",
  },
})

-- Markdown Table of Contents
require("utils.toc").setup()
nmap("<leader>mt", "<Cmd>Toc<CR>", { desc = "Markdown » Table of Contents" })

-- Markdown Tables
local table_utils = require("utils.table")
table_utils.setup()
nmap("st", table_utils.format, { desc = "Table » Format" })
xmap("st", table_utils.format, { desc = "Table » Format (visual)" })
