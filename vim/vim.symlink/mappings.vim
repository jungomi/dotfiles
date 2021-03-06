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
inoremap <expr> <C-j> pumvisible() ? "\<C-n>" : "\<C-j>"
inoremap <expr> <C-k> pumvisible() ? "\<C-p>" : "\<C-k>"

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
" Save current file with sudo
nnoremap <leader>sw :w suda://%<CR>
" Switch between last two files
nnoremap <leader><leader> <C-^>
" Create directory of current file
nnoremap <leader>mkd :call mkdir(expand('%:h'), 'p')<CR>
nnoremap <leader>mkw :call mkdir(expand('%:h'), 'p')<CR>:write<CR>

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
nnoremap <leader>ep :vsp ~/.profile<CR>
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
nnoremap <leader>lo :call OpenDiagnostics()<CR>
nnoremap <leader>lc :lclose<CR>

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
nnoremap <leader>mp :MarkdownPreview<CR>
" Instant latex preview
nnoremap <leader>ilp :LLPStartPreview<CR>
" Git
nnoremap <leader>gb :Git blame<CR>
nnoremap <leader>gc :Gcommit -v<CR>
nnoremap <leader>gd :Gdiffsplit<CR>
nnoremap <leader>gs :Git<CR>
nnoremap <leader>gw :Gwrite<CR>
" Fuzzy finder
nnoremap <leader>ff :Files<CR>
nnoremap <leader>ft :Tags<CR>
nnoremap <leader>fg :GFiles<CR>
" Files showing up in git status
nnoremap <leader>fs :GFiles?<CR>
nnoremap <leader>fc :Commits<CR>
nnoremap <leader>fp :FilesPreview<CR>
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>fh :History<CR>
nnoremap <leader>fr :Rg<space>
" MdnQuery
nmap <leader>me <Plug>MdnqueryEntry
nnoremap <leader>mf :call mdnquery#focus()<CR>
nnoremap <leader>mr :MdnQueryList<CR>
" Asterisk (search word under cursor)
map *   <Plug>(asterisk-*)
map #   <Plug>(asterisk-#)
map g*  <Plug>(asterisk-g*)
map g#  <Plug>(asterisk-g#)
map z*  <Plug>(asterisk-z*)
map gz* <Plug>(asterisk-gz*)
map z#  <Plug>(asterisk-z#)
map gz# <Plug>(asterisk-gz#)

" Coc
" Show (type) info of the word under the cursor
nnoremap <leader>lt :call CocActionAsync('doHover')<CR>
nmap <leader>ld <Plug>(coc-definition)
nmap <leader>lr <Plug>(coc-rename)
" Code actions give you suggestions to fix the warning/error and applies them
nmap <leader>la <Plug>(coc-codeaction)
nnoremap <leader>lf :call CocActionAsync('format')<CR>
nnoremap <leader>ls :call CocActionAsync('showSignatureHelp')<CR>
inoremap <C-s> <C-o>:call CocActionAsync('showSignatureHelp')<CR>
" Highlight occurrences of the word under the cursor
nnoremap <leader>lh :call CocActionAsync('highlight')<CR>
" Organise imports
nnoremap <leader>li :call CocAction('runCommand', 'editor.action.organizeImport')<CR>
" Navigate diagnostics
nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> ]d <Plug>(coc-diagnostic-next)
" Code completion with Ctrl-Space
inoremap <silent><expr> <C-space> coc#refresh()
imap <C-@> <C-space>
" Select completion when menu is open, otherwise trigger snippet completion
" Invokes <Plug>(coc-snippets-expand-jump) unless the menu is visible.
imap <silent><expr> <C-l> pumvisible() ? "\<C-y>" : "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>"
vmap <silent> <C-l> :<C-u>call coc#rpc#request('doKeymap', ['snippets-expand-jump',''])<CR>
" Navigate Git chunks
nmap [g <Plug>(coc-git-prevchunk)
nmap ]g <Plug>(coc-git-nextchunk)
" Show diff of the Git chunk under the currsor
nmap <leader>lg <Plug>(coc-git-chunkinfo)
