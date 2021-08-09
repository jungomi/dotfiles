-- All key mappings for legacy plugins
local map_utils = require("utils.map")
local nmap = map_utils.nmap
local xmap = map_utils.xmap

local M = {}

function M.enable_mappings()
  -- Git
  nmap("<leader>gc", "<Cmd>Git commit -v<CR>")
  nmap("<leader>gd", "<Cmd>Gdiffsplit<CR>")
  nmap("<leader>gs", "<Cmd>Git<CR>")

  -- Fzf
  nmap("<leader>ff", "<Cmd>Files<CR>")
  -- Config files
  nmap("<leader>fv", string.format("<Cmd>Files %s<CR>", vim.fn.stdpath("config")))
  -- History of recently opened files
  nmap("<leader>fh", "<Cmd>History<CR>")
  nmap("<leader>fg", "<Cmd>GFiles<CR>")
  -- Git status
  nmap("<leader>fs", "<Cmd>GFiles?<CR>")
  nmap("<leader>fb", "<Cmd>Buffers<CR>")
  nmap("<leader>ft", "<Cmd>Tags<CR>")
  nmap("<leader>fl", "<Cmd>Lines<CR>")
  nmap("<leader>fm", "<Cmd>Marks<CR>")
  -- Not <Cmd> because it will only start the command, not execute it
  nmap("<leader>fr", ":Rg ")

  -- Asterisk (search word under cursor)
  vim.api.nvim_set_keymap("", "*", "<Plug>(asterisk-*)", {})
  vim.api.nvim_set_keymap("", "#", "<Plug>(asterisk-#)", {})
  vim.api.nvim_set_keymap("", "g*", "<Plug>(asterisk-g*)", {})
  vim.api.nvim_set_keymap("", "g#", "<Plug>(asterisk-g#)", {})
  vim.api.nvim_set_keymap("", "z*", "<Plug>(asterisk-z*)", {})
  vim.api.nvim_set_keymap("", "gz*", "<Plug>(asterisk-gz*)", {})
  vim.api.nvim_set_keymap("", "z#", "<Plug>(asterisk-z#)", {})
  vim.api.nvim_set_keymap("", "gz#", "<Plug>(asterisk-gz#)", {})

  -- Save file with sudo
  nmap("<leader>sw", "<Cmd>w suda://%<CR>")

  -- Undo tree
  nmap("<leader>u", "<Cmd>UndotreeToggle<CR>")

  -- Sandwich (unbind `s` to avoid conflicts / operator pending timeout)
  nmap("s", "")
  xmap("s", "")

  -- Live markdown preview
  nmap("<leader>mp", "<Cmd>MarkdownPreview<CR>")
end

return M
