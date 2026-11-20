local nmap = require("utils.map").nmap

-- Align text
require("utils.align").setup({
  keys = {
    start = "sl",
  },
})

-- Markdown Table of Contents
require("utils.toc").setup()
nmap("<leader>mt", "<Cmd>Toc<CR>", { desc = "Markdown » Table of Contents" })
