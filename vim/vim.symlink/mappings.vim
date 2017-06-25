" Leader key
let mapleader = ","

" Exit insert mode
"inoremap jj <ESC> " jj to exit inster mode
" Disable search highlighting
nnoremap <leader><space> :nohlsearch<cr>
" Strip trailing whitespace
nnoremap <leader>W :call StripTrailingWhitespaces()<CR>
" Select pasted text
nnoremap <leader>v `[v`]
" Toggle spell check
nnoremap <leader>sc :set spell!<CR>
" Markdown table replace line with header separator
nnoremap <leader>mth :let @m='lvt\|r-f\|@m'<CR>:normal @m<CR>

" ⚑ Movement
" Move by visual lines
nnoremap j gj
nnoremap k gk
" Move by line numbers
nnoremap gj j
nnoremap gk k
" Speed up scrolling
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

" ⚑ Completion menu
" Movement
inoremap <expr> j pumvisible() ? "\<C-n>" : "j"
inoremap <expr> k pumvisible() ? "\<C-p>" : "k"
" Cancel completion with Esc
inoremap <expr> <Esc> pumvisible() ? "\<C-e>" : "\<Esc>"
" Code completion with Ctrl-Space
inoremap <C-space> <C-x><C-o>
imap <C-@> <C-space>

" ⚑ Disable mappings
" Remove help key
inoremap <F1> <nop>
nnoremap <F1> <nop>
vnoremap <F1> <nop>
" Disable Ex mode
noremap Q <NOP>

" ⚑ Buffer
" Save
nnoremap <leader>w :w<CR>
" Abuse tee for sudo save
nnoremap <leader>sw :w !sudo tee % > /dev/null<CR>
" Switch between last two files
nnoremap <leader><leader> <C-^>
" Create directory of current file
nnoremap <leader>mkd :!mkdir -p %:h<CR><CR>

" ⚑ Clipboard
" Save
nnoremap <leader>y "+y
xnoremap <leader>y "+y
" Paste
nnoremap <leader>p "+p
xnoremap <leader>p "+p

" ⚑ Configs
" Open configs in a split
nnoremap <leader>eb :vsp ~/.bashrc<CR>
nnoremap <leader>et :vsp ~/.tmux.conf<CR>
nnoremap <leader>eg :vsp ~/.gitconfig<CR>
nnoremap <leader>ev :vsp $MYVIMRC<CR>
" Reload vimrc
nnoremap <leader>sv :source $MYVIMRC<CR>

" ⚑ Split windows
" Create horizontal split and switch to it
nnoremap <leader>T <C-w>s
" Create vertical split and switch to it
nnoremap <leader>t <C-w>v
" Navigation between windows
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" Resize all splits evenly
nnoremap <leader>= <C-w>=
" Maximise current split
nnoremap <leader>z <C-w>_<C-w>\|

" ⚑ Tests
" All
nnoremap <leader>rta :call RunTest()<CR>
" Current file only
nnoremap <leader>rtc :call RunTest('%')<CR>

" ⚑ Tags
" Go to definition under cursor
nnoremap <leader>gf <C-]>
" Show definition under cursor in preview window
nnoremap <leader>gt <C-W>}
" Show multiple definition under cursor in preview window
nnoremap <leader>gT <C-W>g}
" Generate/Create tags
nnoremap <leader>ct :AsyncRun ctags -f .tags -R .<CR>

" ⚑ Plugins
nnoremap <leader>u :UndotreeToggle<CR>
" Markdown preview
nnoremap <leader>mp :LivedownPreview<CR>
" Instant latex preview
nnoremap <leader>ilp :LLPStartPreview<CR>
" Fuzzy finder
nnoremap <leader>ff :Files<CR>
nnoremap <leader>ft :Tags<CR>
nnoremap <leader>fg :GFiles<CR>
" Files showing up in git status
nnoremap <leader>fs :GFiles?<CR>
nnoremap <leader>fc :Commits<CR>
nnoremap <leader>fp :FilesPreview<CR>
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>fr :Rg<space>
" MdnQuery
nmap <leader>me <Plug>MdnqueryEntry
nnoremap <leader>mf :call mdnquery#focus()<CR>
nnoremap <leader>mr :MdnQueryList<CR>
" Toggle linting
nnoremap <leader>lt :ALEToggle<CR>
" Auto fix file configure in g:ale_fixers
nnoremap <leader>af :ALEFix<CR>
