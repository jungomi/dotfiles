local opt = vim.opt

-- :: Appearance
opt.syntax = "on"
opt.termguicolors = true
opt.number = true
opt.hidden = true
opt.lazyredraw = false
opt.background = "light"
opt.updatetime = 300
-- Only enable mouse in command mode, don't want any mouse support really, but that's the
-- one place it could see myself using it (because other bindings don't really work well)
opt.mouse = "c"
-- Leave my cursor alone, don't want a different cursor in different modes
opt.guicursor = "a:block"
opt.title = true
opt.shortmess = "atIcF"
-- Always show the sign gutter
opt.signcolumn = "yes"
-- Show the current unfinished command in the statusline
opt.showcmdloc = "statusline"

-- :: Line settings
opt.formatoptions = "1crqnlj"
-- Visually wrap lines
opt.wrap = true
-- Indent visually broken lines to the same level as the actual line
opt.breakindent = true
opt.textwidth = 120
opt.colorcolumn = "+1"
-- Show 3 lines around cursor
opt.scrolloff = 3
opt.sidescrolloff = 3
-- Highlight current line
opt.cursorline = true
-- Don't show ~ for non-existing lines at end of buffer
opt.fillchars = { eob = " ", fold = " ", foldopen = "", foldsep = "┃", foldclose = "", diff = "╱" }

-- :: File settings
opt.encoding = "utf-8"
opt.spelllang = "en_gb"

-- :: Indentation
opt.expandtab = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.smartindent = true
opt.cindent = true
opt.autoindent = true

-- :: Splits
-- Split windows more naturally (below/right)
opt.splitbelow = true
opt.splitright = true
-- Diff vertically
opt.diffopt:append({ "vertical" })

-- :: Search
opt.ignorecase = true
-- Case sensitive when using uppercase
opt.smartcase = true
-- Enable 'g' flag by default in substitutions
opt.gdefault = true
opt.showmatch = true
-- Remove tag completion form regular completion (<C-n>)
opt.complete:remove({ "t" })
opt.tags:append({ ".tags" })

-- :: Completion
opt.completeopt = { "longest", "menuone", "noselect" }
opt.wildmode = "longest:full"

-- :: Code folding
opt.foldenable = false
opt.foldlevel = 10

-- :: Backups
opt.swapfile = false
-- Keep undo history
opt.undofile = true
-- Always copy and overwrite file when it's saved (some watch modes require this)
opt.backupcopy = "yes"
