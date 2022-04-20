-- All key mappings for legacy plugins
local map_utils = require("utils.map")
local map = map_utils.map
local nmap = map_utils.nmap
local xmap = map_utils.xmap

local M = {}

function M.enable_mappings()
  -- Git
  nmap("<leader>gc", "<Cmd>Git commit -v<CR>", { desc = "Git » Commit" })
  nmap("<leader>gd", "<Cmd>Gdiffsplit<CR>", { desc = "Git » Diff" })
  nmap("<leader>gs", "<Cmd>Git<CR>", { desc = "Git » Status" })

  -- Fzf
  nmap("<leader>ff", "<Cmd>Files<CR>", { desc = "Fzf » Files" })
  -- Config files
  nmap("<leader>fv", string.format("<Cmd>Files %s<CR>", vim.fn.stdpath("config")), { desc = "Fzf » Configs" })
  -- History of recently opened files
  nmap("<leader>fh", "<Cmd>History<CR>", { desc = "Fzf » History" })
  nmap("<leader>fg", "<Cmd>GFiles<CR>", { desc = "Fzf » Git files" })
  -- Git status
  nmap("<leader>fs", "<Cmd>GFiles?<CR>", { desc = "Fzf » Git status" })
  nmap("<leader>fb", "<Cmd>Buffers<CR>", { desc = "Fzf » Buffers" })
  nmap("<leader>ft", "<Cmd>Tags<CR>", { desc = "Fzf » Tags" })
  nmap("<leader>fl", "<Cmd>Lines<CR>", { desc = "Fzf » Lines" })
  nmap("<leader>fm", "<Cmd>Marks<CR>", { desc = "Fzf » Marks" })
  -- Not <Cmd> because it will only start the command, not execute it
  nmap("<leader>fr", ":Rg ", { desc = "Fzf » Ripgrep" })

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
