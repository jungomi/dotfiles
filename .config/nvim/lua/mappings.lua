local map_utils = require("utils.map")
local t = map_utils.t
local nmap = map_utils.nmap
local imap = map_utils.imap
local cmap = map_utils.cmap
local vmap = map_utils.vmap
local xmap = map_utils.xmap
local smap = map_utils.smap

vim.g.mapleader = ","

-- :: Buffer
nmap("<leader>w", "<Cmd>w<CR>")
-- Switch between last two files
nmap("<leader><leader>", "<C-^>")

-- :: Movement
-- Move by visual lines
nmap("j", "gj")
nmap("k", "gk")
-- Move by line numbers
nmap("gj", "j")
nmap("gk", "k")
-- Speed up scrolling
nmap("<C-e>", "3<C-e>")
nmap("<C-y>", "3<C-y>")

-- :: Splits
-- Horizontal split
nmap("<leader>T", "<C-w>s")
-- Vertical split
nmap("<leader>t", "<C-w>v")
-- Navigation between windows
nmap("<C-h>", "<C-w>h")
nmap("<C-j>", "<C-w>j")
nmap("<C-k>", "<C-w>k")
nmap("<C-l>", "<C-w>l")
-- Resize all splits evenly
nmap("<leader>=", "<C-w>=")
-- Maximise current split
nmap("<leader>z", "<C-w>_<C-w>|")

-- :: Navigation
-- General buffer list navigations, similar to vim-unimpaired
nmap("[a", "<Cmd>prev<CR>")
nmap("]a", "<Cmd>next<CR>")
nmap("[A", "<Cmd>first<CR>")
nmap("]A", "<Cmd>last<CR>")
nmap("[b", "<Cmd>bprev<CR>")
nmap("]b", "<Cmd>bnext<CR>")
nmap("[B", "<Cmd>bfirst<CR>")
nmap("]B", "<Cmd>blast<CR>")
nmap("[l", "<Cmd>lprev<CR>")
nmap("]l", "<Cmd>lnext<CR>")
nmap("[L", "<Cmd>lfirst<CR>")
nmap("]L", "<Cmd>llast<CR>")
nmap("[q", "<Cmd>cprev<CR>")
nmap("]q", "<Cmd>cnext<CR>")
nmap("[Q", "<Cmd>cfirst<CR>")
nmap("]Q", "<Cmd>clast<CR>")
nmap("[t", "<Cmd>tabprev<CR>")
nmap("]t", "<Cmd>tabnext<CR>")
nmap("[T", "<Cmd>tabfirst<CR>")
nmap("]T", "<Cmd>tablast<CR>")


-- :: Clipboard
nmap("<leader>y", [["+y]])
xmap("<leader>y", [["+y]])
nmap("<leader>p", [["+p]])
xmap("<leader>p", [["+p]])

-- :: Completion Menu
-- Completion menu mappings need a workaround for the term escaping in Lua
-- <C-j>
_G.completion_menu_next = function()
  if vim.fn.pumvisible() == 1 then
    return t"<C-n>"
  else
    return t"<C-j>"
  end
end

-- <C-k>
_G.completion_menu_prev = function()
  if vim.fn.pumvisible() == 1 then
    return t"<C-p>"
  else
    return t"<C-k>"
  end
end

-- <C-l>
_G.completion_expand = function()
  if vim.fn.pumvisible() == 1 then
    return vim.fn["compe#confirm"](t"<C-y>")
  elseif vim.fn["vsnip#available"](1) == 1 then
    return t"<Plug>(vsnip-expand-or-jump)"
  else
    return ""
  end
end

-- <C-h>
_G.snip_prev = function()
  if vim.fn["vsnip#jumpable"](-1) == 1 then
    return t"<Plug>(vsnip-jump-prev)"
  else
    return t"<C-h>"
  end
end

imap("<C-j>", "v:lua.completion_menu_next()", { expr = true })
cmap("<C-j>", "v:lua.completion_menu_next()", { expr = true })
imap("<C-k>", "v:lua.completion_menu_prev()", { expr = true })
cmap("<C-k>", "v:lua.completion_menu_prev()", { expr = true })
-- Cannot be noremap because they use a <Plug>(...) mapping
imap("<C-l>", "v:lua.completion_expand()", { expr = true, noremap = false })
cmap("<C-l>", "v:lua.completion_expand()", { expr = true, noremap = false })
smap("<C-l>", "v:lua.completion_expand()", { expr = true, noremap = false })
imap("<C-h>", "v:lua.snip_prev()", { expr = true, noremap = false })
smap("<C-h>", "v:lua.snip_prev()", { expr = true, noremap = false })

-- On some systems <C-space> is <C-@> for some reason
nmap("<C-@>", "<C-space>", { noremap = false })

-- :: Tags
-- Go to definition
nmap("<leader>gf", "<C-]>")
-- Show definition in preview window
nmap("<leader>gt", "<C-w>}")
-- Show multiple definitions in preview window
nmap("<leader>gT", "<C-w>}g")

-- :: Misc
nmap("<leader><space>", "<Cmd>nohlsearch<CR>")
-- Selected pasted text
nmap("<leader>v", "`[v`]")
-- Toggle specllcheck
nmap("<leader>sc", "<Cmd>set spell!<CR>")
-- Remove trailing whitespace (becomes an easy oneliner with Lua)
nmap("<leader>rw", [[<Cmd>luado return line:gsub("^(.-)%s*$", "%1")<CR>]])

-- :: Configs
-- Open configs in a split
nmap("<leader>eb", "<Cmd>vsp ~/.config/bash/bashrc<CR>")
nmap("<leader>ep", "<Cmd>vsp ~/.profile<CR>")
nmap("<leader>et", "<Cmd>vsp ~/.config/tmux/tmux.conf<CR>")
nmap("<leader>eg", "<Cmd>vsp ~/.config/git/config<CR>")

-- :: Disable unused mappings
imap("<F1>", "")
nmap("<F1>", "")
vmap("<F1>", "")
nmap("Q", "")
