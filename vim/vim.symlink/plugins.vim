set nocompatible
filetype off

call plug#begin('~/.vim/plugged')
" Colour schemes
Plug 'chriskempson/base16-vim'

Plug 'rking/ag.vim'
" Manipulate surrounding parentheses, quotes, etc.
Plug 'tpope/vim-surround'
" Make plugin commands repeatable
Plug 'tpope/vim-repeat'
" Align text
Plug 'godlygeek/tabular'
" Linter
Plug 'neomake/neomake'
Plug 'ap/vim-buftabline'
" Asynchronous calls
Plug 'skywind3000/asyncrun.vim'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-commentary'
" Transform between single and multi line
Plug 'AndrewRadev/splitjoin.vim'

" ⚑ Navigation
" Fuzzy file finder
Plug 'ctrlpvim/ctrlp.vim'
" Mappings for easier navigation
Plug 'tpope/vim-unimpaired'
" Navigation for projections.json configurations
Plug 'tpope/vim-projectionist'
" Undo Tree
Plug 'mbbill/undotree'

" ⚑ Snippets
" Snippet engine
Plug 'MarcWeber/vim-addon-mw-utils' | Plug 'tomtom/tlib_vim' | Plug 'garbas/vim-snipmate'
Plug 'honza/vim-snippets'
" Expand keywords to HTML
Plug 'mattn/emmet-vim'

" ⚑ Git
" Wrapper
Plug 'tpope/vim-fugitive'
" Diff signs next to line numbers
Plug 'airblade/vim-gitgutter'
" GitHub gist
Plug 'mattn/webapi-vim' | Plug 'mattn/gist-vim'

" ⚑ Filetype specific
" C
Plug 'vim-scripts/a.vim', { 'for': ['c', 'cpp', 'objc', 'objcpp'] }
Plug 'justinmk/vim-syntax-extra', { 'for': 'c' }
" Coffescript
Plug 'kchmck/vim-coffee-script', { 'for': 'coffee' }
" CSS
Plug 'ap/vim-css-color', { 'for': 'css' }
Plug 'wavded/vim-stylus', { 'for': 'stylus' }
" HTML
Plug 'othree/html5.vim'
" Java
Plug 'artur-shaik/vim-javacomplete2', { 'for': 'java' }
" JavaScript
Plug 'pangloss/vim-javascript', { 'for': ['javascript', 'markdown', 'mdnquery'] }
Plug 'jungomi/vim-mdnquery'
" JSON
Plug 'elzr/vim-json', { 'for': 'json' }
" JSX
Plug 'mxw/vim-jsx', { 'for': 'javascript' }
" Markdown
Plug 'tpope/vim-markdown', { 'for': ['markdown', 'mdnquery'] }
Plug 'shime/vim-livedown', { 'for': 'markdown' }
" Mustache and handlebars
Plug 'mustache/vim-mustache-handlebars', { 'for': ['html.handlebars', 'html.mustache'] }
" Latex
Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }
Plug 'gi1242/vim-tex-syntax', { 'for': 'tex' }
" Ruby
Plug 'vim-ruby/vim-ruby', { 'for': 'ruby' }
Plug 'tpope/vim-rake', { 'for': ['ruby', 'eruby'] }
Plug 'tpope/vim-bundler', { 'for': ['ruby', 'eruby'] }
Plug 'tpope/vim-rails', { 'for': ['ruby', 'eruby'] }
" Rust
Plug 'rust-lang/rust.vim', { 'for': 'rust' }
" TOML
Plug 'cespare/vim-toml', { 'for': 'toml' }
" TypeScript
Plug 'leafgarland/typescript-vim', { 'for': 'typescript' }
" Vue
Plug 'posva/vim-vue', { 'for': 'vue' }

call plug#end()

filetype plugin indent on
