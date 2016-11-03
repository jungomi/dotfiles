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

" === Movement ===
" Move by visual lines
nnoremap j gj
nnoremap k gk
" Move by line numbers
nnoremap gj j
nnoremap gk k
" Speed up scrolling
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>
" Use tab to move to matching brackets
nnoremap <tab> %
vnoremap <tab> %

" === Completion menu ===
" Movement
inoremap <expr> j pumvisible() ? "\<C-n>" : "j"
inoremap <expr> k pumvisible() ? "\<C-p>" : "k"
" Cancel completion with Esc
inoremap <expr> <Esc> pumvisible() ? "\<C-e>" : "\<Esc>"
" Code completion with Ctrl-Space
inoremap <C-@> <C-x><C-o>

" === Disable mappings ===
" Remove help key
inoremap <F1> <nop>
nnoremap <F1> <nop>
vnoremap <F1> <nop>
" Disable Ex mode
noremap Q <NOP>

" === Buffer ===
" Save
nnoremap <leader>w :w<CR>
" Abuse tee for sudo save
nnoremap <leader>sw :w !sudo tee % > /dev/null<CR>
" Switch between last two files
nnoremap <leader><leader> <C-^>
" Create directory of current file
nnoremap <leader>mkd :!mkdir -p %:h<CR><CR>

" === Clipboard ===
" Save
nnoremap <leader>y "+y
xnoremap <leader>y "+y
" Paste
nnoremap <leader>p "+p
xnoremap <leader>p "+p

" === Configs ===
" Open configs in a split
nnoremap <leader>eb :vsp ~/.bashrc<CR>
nnoremap <leader>et :vsp ~/.tmux.conf<CR>
nnoremap <leader>eg :vsp ~/.gitconfig<CR>
nnoremap <leader>ev :vsp $MYVIMRC<CR>
" Reload vimrc
nnoremap <leader>sv :source $MYVIMRC<CR>

" === Split windows ===
" Create horizontal split and switch to it
nnoremap <leader>T <C-w>s<C-w>j
" Create vertical split and switch to it
nnoremap <leader>t <C-w>v<C-w>l
" Navigation between windows
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" Resizing current split
nnoremap <leader>j :resize +5<CR>
nnoremap <leader>k :resize -5<CR>
nnoremap <leader>l :vertical resize +5<CR>
nnoremap <leader>h :vertical resize -5<CR>
" Resize all splits evenly
nnoremap <leader>= <C-w>=

" === tests ===
" All
nnoremap <leader>rta :call RunTestAll()<CR>
" Current file only
nnoremap <leader>rtc :call RunTestCurrent()<CR>

" === Tags ===
" Go to definition under cursor
nnoremap <leader>gf <C-]>
" Show definition under cursor in preview window
nnoremap <leader>gt <C-W>}
" Show multiple definition under cursor in preview window
nnoremap <leader>gT <C-W>g}

" === Plugins ===
nnoremap <leader>a :Ag<space>
nnoremap <leader>u :UndotreeToggle<CR>
" Nerdtree
nnoremap <leader>nt :NERDTreeToggle<CR>
" Find current file in tree
nnoremap <leader>nf :NERDTreeFind<CR>
nnoremap <leader>nbc :Bookmark<CR>
" Instant markdown preview
nnoremap <leader>imp :InstantMarkdownPreview<CR>
" Instant latex preview
nnoremap <leader>ilp :LLPStartPreview<CR>
" CtrlP
nnoremap <leader>ff :CtrlP<CR>
nnoremap <leader>ft :CtrlPTag<CR>
