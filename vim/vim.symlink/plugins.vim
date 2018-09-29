set nocompatible
filetype off

call plug#begin('~/.vim/plugged')
" Manipulate surrounding parentheses, quotes, etc.
Plug 'tpope/vim-surround'
" Make plugin commands repeatable
Plug 'tpope/vim-repeat'
" Align text
Plug 'godlygeek/tabular'
" Linter
Plug 'w0rp/ale'
Plug 'ap/vim-buftabline'
" Asynchronous calls
Plug 'skywind3000/asyncrun.vim'
" Substitute different cases (camelCase, snake_case, etc.) and plurals
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-commentary'
" Transform between single and multi line
Plug 'AndrewRadev/splitjoin.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'wellle/tmux-complete.vim'
" Swap two regions of text
Plug 'tommcdo/vim-exchange'
" LSP
Plug 'autozimu/LanguageClient-neovim', {
      \ 'branch': 'next',
      \ 'do': 'bash install.sh',
      \ }

" ⚑ Navigation
" Fuzzy file finder
Plug 'junegunn/fzf', { 'dir': '~/.fzf' }
Plug 'junegunn/fzf.vim'
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
Plug 'mhinz/vim-signify'
" GitHub gist
Plug 'mattn/webapi-vim' | Plug 'mattn/gist-vim'
" Interactive git integration
Plug 'jreybert/vimagit'
" Show diff when using: git rebase --interactive
Plug 'hotwatermorning/auto-git-diff'

" ⚑ Filetype specific
" C
Plug 'vim-scripts/a.vim', { 'for': ['c', 'cpp', 'objc', 'objcpp'] }
Plug 'justinmk/vim-syntax-extra', { 'for': 'c' }
" Coffescript
Plug 'kchmck/vim-coffee-script', { 'for': 'coffee' }
" Crystal
Plug 'rhysd/vim-crystal', { 'for': 'crystal' }
" CSS
Plug 'ap/vim-css-color'
Plug 'wavded/vim-stylus', { 'for': 'stylus' }
" Elm
Plug 'ElmCast/elm-vim', { 'for': 'elm' }
" Go
Plug 'fatih/vim-go', { 'for': 'go' }
" Haskell
Plug 'neovimhaskell/haskell-vim', { 'for': 'haskell' }
" HTML
Plug 'othree/html5.vim'
" Java
Plug 'artur-shaik/vim-javacomplete2', { 'for': 'java' }
" JavaScript
Plug 'pangloss/vim-javascript', { 'for': ['javascript', 'markdown', 'mdnquery'] }
Plug 'jungomi/vim-mdnquery'
Plug 'heavenshell/vim-jsdoc', { 'for': 'javascript' }
" JSON
Plug 'elzr/vim-json', { 'for': 'json' }
" JSX
Plug 'mxw/vim-jsx', { 'for': 'javascript' }
" LLVM
Plug 'llvm-mirror/llvm', { 'rtp': 'utils/vim', 'for': ['llvm', 'tablegen'] }
" Markdown
Plug 'tpope/vim-markdown', { 'for': ['markdown', 'mdnquery'] }
Plug 'shime/vim-livedown', { 'for': 'markdown' }
Plug 'mzlogin/vim-markdown-toc', { 'for': 'markdown' }
" Mustache and handlebars
Plug 'mustache/vim-mustache-handlebars', { 'for': ['html.handlebars', 'html.mustache'] }
" Latex
Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }
Plug 'gi1242/vim-tex-syntax', { 'for': 'tex' }
" R
Plug 'jalvesaq/Nvim-R'
" ReasonML
Plug 'reasonml-editor/vim-reason-plus'
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
Plug 'ianks/vim-tsx', { 'for': 'typescript' }
" Vue
Plug 'posva/vim-vue', { 'for': 'vue' }
" Wasm
Plug 'rhysd/vim-wasm', { 'for': 'wast' }

call plug#end()

filetype plugin indent on
