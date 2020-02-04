set nocompatible
filetype off

call plug#begin('~/.vim/plugged')
" Manipulate surrounding parentheses, quotes, etc.
Plug 'tpope/vim-surround'
" Make plugin commands repeatable
Plug 'tpope/vim-repeat'
" Align text
Plug 'godlygeek/tabular'
Plug 'ap/vim-buftabline'
" Asynchronous calls
Plug 'skywind3000/asyncrun.vim'
" Substitute different cases (camelCase, snake_case, etc.) and plurals
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
" Transform between single and multi line
Plug 'AndrewRadev/splitjoin.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'wellle/tmux-complete.vim'
" Swap two regions of text
Plug 'tommcdo/vim-exchange'
" Completion, LSP and more extensions (using VSCode extensions)
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" ⚑ Navigation
" Fuzzy file finder
Plug 'junegunn/fzf', { 'dir': '~/.fzf' }
Plug 'junegunn/fzf.vim'
" Mappings for easier navigation
Plug 'tpope/vim-unimpaired'
" Undo Tree
Plug 'mbbill/undotree'
" Smooth scrolling
Plug 'psliwka/vim-smoothie'
" Better search under cursor (smart case, visual *, etc.)
Plug 'haya14busa/vim-asterisk'

" ⚑ Snippets
" Useful Snippets for many languages
Plug 'honza/vim-snippets'
" Expand keywords to HTML
Plug 'mattn/emmet-vim'

" ⚑ Git
" Wrapper
Plug 'tpope/vim-fugitive'
" Show diff when using: git rebase --interactive
Plug 'hotwatermorning/auto-git-diff'

Plug 'jalvesaq/vimcmdline'

" Save/Open with sudo (replaces the tee sudo trick)
Plug 'lambdalisue/suda.vim'
" ⚑ Filetype specific
" C
Plug 'vim-scripts/a.vim', { 'for': ['c', 'cpp', 'objc', 'objcpp'] }
Plug 'justinmk/vim-syntax-extra', { 'for': 'c' }
Plug 'bfrg/vim-cpp-modern', { 'for': ['c', 'cpp', 'objc', 'objcpp'] }
" Coffescript
Plug 'kchmck/vim-coffee-script', { 'for': 'coffee' }
" Crystal
Plug 'rhysd/vim-crystal', { 'for': 'crystal' }
" CSV
Plug 'chrisbra/csv.vim'
Plug 'wavded/vim-stylus', { 'for': 'stylus' }
" Elm
Plug 'ElmCast/elm-vim', { 'for': 'elm' }
" Go
Plug 'fatih/vim-go', { 'for': 'go' }
" Haskell
Plug 'neovimhaskell/haskell-vim', { 'for': 'haskell' }
" HTML
Plug 'othree/html5.vim'
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
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install', 'for': 'markdown'  }
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
" Configuring the highlighting is an absolute nightmare, since yats defines no
" common highlight group but instead defines 100s of different kinds of methods
" e.g. typescriptPromiseMethod, typescriptStringMethod etc.
" and links them directly to Keyword, which makes so no sense at all, since they
" are not keywords, but should at least link to Function. Either way, if you
" want to change them you need to re-link all of them, and they are also
" scattered around the repo, so they are just changed when seen for the first
" time.
" Indentation for JSX is also bad.
" Unfortunately, the alternatives are just as bad and for the syntax
" highlighting even worse.
Plug 'HerringtonDarkholme/yats.vim', { 'for': 'typescript' }
" Vue
Plug 'posva/vim-vue', { 'for': 'vue' }
" Wasm
Plug 'rhysd/vim-wasm', { 'for': 'wast' }

call plug#end()

filetype plugin indent on
