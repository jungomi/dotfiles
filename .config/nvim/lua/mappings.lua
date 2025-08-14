local map_utils = require("utils.map")
local map = map_utils.map
local nmap = map_utils.nmap
local imap = map_utils.imap
local cmap = map_utils.cmap
local vmap = map_utils.vmap
local xmap = map_utils.xmap

vim.g.mapleader = ","

-- :: Buffer
nmap("<leader>w", "<Cmd>w<CR>", { desc = "Save" })
-- Switch between last two files
nmap("<leader><leader>", "<C-^>", { desc = "Switch between last two files" })

-- :: Movement
-- Move by visual lines
nmap("j", "gj", { desc = "Movement » Down" })
nmap("k", "gk", { desc = "Movement » Up" })
-- Move by line numbers
nmap("gj", "j", { desc = "Movement » Down (line number)" })
nmap("gk", "k", { desc = "Movement » Up (line number)" })
-- Speed up scrolling
nmap("<C-e>", "3<C-e>", { desc = "Movement » Scroll Down (3x)" })
nmap("<C-y>", "3<C-y>", { desc = "Movement » Scroll Up (3x)" })

-- :: Splits
-- Horizontal split
nmap("<leader>T", "<C-w>s", { desc = "Window » Split horizontal" })
-- Vertical split
nmap("<leader>t", "<C-w>v", { desc = "Window » Split vertical" })
-- Navigation between windows
nmap("<C-h>", "<C-w>h", { desc = "Window » Left" })
nmap("<C-j>", "<C-w>j", { desc = "Window » Right" })
nmap("<C-k>", "<C-w>k", { desc = "Window » Up" })
nmap("<C-l>", "<C-w>l", { desc = "Window » Down" })
-- Resize all splits evenly
nmap("<leader>=", "<C-w>=", { desc = "Window » Resize evenly" })
-- Maximise current split
nmap("<leader>z", "<C-w>_<C-w>|", { desc = "Window » Maximise" })

-- :: Navigation
-- General buffer list navigations, similar to vim-unimpaired
nmap("[b", "<Cmd>bprev<CR>", { desc = "Buffer » Previous" })
nmap("]b", "<Cmd>bnext<CR>", { desc = "Buffer » Next" })
nmap("[B", "<Cmd>bfirst<CR>", { desc = "Buffer » First" })
nmap("]B", "<Cmd>blast<CR>", { desc = "Buffer » Last" })
nmap("[l", "<Cmd>lprev<CR>", { desc = "Location list » Previous" })
nmap("]l", "<Cmd>lnext<CR>", { desc = "Location list » Next" })
nmap("[L", "<Cmd>lfirst<CR>", { desc = "Location list » First" })
nmap("]L", "<Cmd>llast<CR>", { desc = "Location list » Last" })
nmap("[q", "<Cmd>cprev<CR>", { desc = "Quickfix » Previous" })
nmap("]q", "<Cmd>cnext<CR>", { desc = "Quickfix » Next" })
nmap("[Q", "<Cmd>cfirst<CR>", { desc = "Quickfix » First" })
nmap("]Q", "<Cmd>clast<CR>", { desc = "Quickfix » Last" })
nmap("[t", "<Cmd>tabprev<CR>", { desc = "Tab » Next" })
nmap("]t", "<Cmd>tabnext<CR>", { desc = "Tab » Prev" })
nmap("[T", "<Cmd>tabfirst<CR>", { desc = "Tab » First" })
nmap("]T", "<Cmd>tablast<CR>", { desc = "Tab » Last" })

-- :: Clipboard
nmap("<leader>y", [["+y]], { desc = "Clipboard » Copy" })
xmap("<leader>y", [["+y]], { desc = "Clipboard » Copy" })
nmap("<leader>p", [["+p]], { desc = "Clipboard » Paste" })
xmap("<leader>p", [["+p]], { desc = "Clipboard » Paste" })

-- :: Completion Menu
-- Completion menu mappings need a workaround for the term escaping in Lua
-- <C-j>
local function completion_menu_next()
  if vim.fn.pumvisible() == 1 then
    return "<C-n>"
  else
    return "<C-j>"
  end
end

-- <C-k>
local function completion_menu_prev()
  if vim.fn.pumvisible() == 1 then
    return "<C-p>"
  else
    return "<C-k>"
  end
end

-- <C-l>
-- Confirm selection with <C-l> if the menu is open.
local function completion_menu_confirm()
  if vim.fn.pumvisible() == 1 then
    return "<C-y>"
  end
end

imap("<C-j>", completion_menu_next, { expr = true }, { desc = "Completion » Down" })
cmap("<C-j>", completion_menu_next, { expr = true }, { desc = "Completion » Down" })
imap("<C-k>", completion_menu_prev, { expr = true }, { desc = "Completion » Up" })
cmap("<C-k>", completion_menu_prev, { expr = true }, { desc = "Completion » Up" })
imap("<C-l>", completion_menu_confirm, { expr = true }, { desc = "Completion » Confirm" })
cmap("<C-l>", completion_menu_confirm, { expr = true }, { desc = "Completion » Confirm" })

-- On some systems <C-space> is <C-@> for some reason
imap("<C-@>", "<C-space>", { remap = true })

-- :: Tags
-- Go to definition
nmap("<leader>gf", "<C-]>", { desc = "Tags » Go to definition" })
-- Show definition in preview window
nmap("<leader>gt", "<C-w>}", { desc = "Tags » Show definition (preview)" })
-- Show multiple definitions in preview window
nmap("<leader>gT", "<C-w>}g", { desc = "Tags » Show definition (preview - multiple definitions)" })

-- :: Misc
nmap("<leader><space>", "<Cmd>nohlsearch<CR>", { desc = "Disable search highlight" })
-- Selected pasted text
nmap("<leader>v", "`[v`]", { desc = "Select pasted text" })
-- Toggle specllcheck
nmap("<leader>sc", "<Cmd>set spell!<CR>", { desc = "Toggle spell check" })
-- Remove trailing whitespace (becomes an easy oneliner with Lua)
nmap("<leader>rw", [[<Cmd>luado return line:gsub("^(.-)%s*$", "%1")<CR>]], { desc = "Remove trailing whitespace" })

-- :: Configs
-- Open configs in a split
nmap("<leader>eb", "<Cmd>vsp ~/.config/bash/bashrc<CR>", { desc = "Config » Bash (split)" })
nmap("<leader>ep", "<Cmd>vsp ~/.profile<CR>", { desc = "Config » Bash profile (split)" })
nmap("<leader>et", "<Cmd>vsp ~/.config/tmux/tmux.conf<CR>", { desc = "Config » Tmux (split)" })
nmap("<leader>eg", "<Cmd>vsp ~/.config/git/config<CR>", { desc = "Config » Git (split)" })

-- :: Disable unused mappings
imap("<F1>", "")
nmap("<F1>", "")
vmap("<F1>", "")
nmap("Q", "")

-- For some reason the default of Tab is now to jump in snippets.
-- Just give me my regular tab.
map({ "i", "s" }, "<Tab>", "<Tab>")
map({ "i", "s" }, "<S-Tab>", "<S-Tab>")
