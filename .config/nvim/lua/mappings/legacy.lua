-- All key mappings for legacy plugins
local map_utils = require("utils.map")
local map = map_utils.map
local nmap = map_utils.nmap
local xmap = map_utils.xmap

local M = {}

function M.enable_mappings()
  -- Asterisk (search word under cursor)
  map("", "*", "<Plug>(asterisk-*)", { remap = true, desc = "Search » Forward" })
  map("", "#", "<Plug>(asterisk-#)", { remap = true, desc = "Search » Backward" })
  map("", "g*", "<Plug>(asterisk-g*)", { remap = true, desc = "Search » Forward (not exact)" })
  map("", "g#", "<Plug>(asterisk-g#)", { remap = true, desc = "Search » Backward (not exact)" })
  map("", "z*", "<Plug>(asterisk-z*)", { remap = true, desc = "Search » Forward (stay)" })
  map("", "gz*", "<Plug>(asterisk-gz*)", { remap = true, desc = "Search » Forward (stay - not exact)" })
  map("", "z#", "<Plug>(asterisk-z#)", { remap = true, desc = "Search » Backward (stay)" })
  map("", "gz#", "<Plug>(asterisk-gz#)", { remap = true, desc = "Search » Backward (stay - not exact)" })

  -- Save file with sudo
  nmap("<leader>sw", "<Cmd>w suda://%<CR>", { desc = "Save with sudo" })

  -- Undo tree
  nmap("<leader>u", "<Cmd>UndotreeToggle<CR>", { desc = "Undotree » Toggle" })

  -- Sandwich (unbind `s` to avoid conflicts / operator pending timeout)
  nmap("s", "")
  xmap("s", "")

  -- Live markdown preview
  nmap("<leader>mp", "<Cmd>MarkdownPreview<CR>", { desc = "Markdown preview" })
end

return M
