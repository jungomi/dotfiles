set nocompatible
filetype off

call plug#begin('~/.vim/plugged')
Plug 'chriskempson/base16-vim'

Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
Plug 'mileszs/ack.vim'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'garbas/vim-snipmate'
Plug 'honza/vim-snippets'
Plug 'rstacruz/sparkup', {'rtp': 'vim/'}
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-fugitive'
Plug 'sjl/gundo.vim', {'ŕtp': 'plugin/'}
Plug 'godlygeek/tabular'
Plug 'scrooloose/syntastic'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'bling/vim-airline'
Plug 'tpope/vim-dispatch'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-unimpaired'
Plug 'ap/vim-css-color', { 'for': 'css' }
Plug 'elzr/vim-json', { 'for': 'json' }
" markdown
Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
Plug 'suan/vim-instant-markdown', { 'for': 'markdown' }
Plug 'mattn/webapi-vim'
Plug 'mattn/gist-vim'
Plug 'artur-shaik/vim-javacomplete2', { 'for': 'java' }
" Javascript syntax and indentation
Plug 'jelera/vim-javascript-syntax', { 'for': 'javascript' }
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
" mustache and handlebars
Plug 'mustache/vim-mustache-handlebars', { 'for': ['html.handlebars', 'html.mustache'] }
Plug 'tpope/vim-projectionist'
" ruby
Plug 'vim-ruby/vim-ruby', { 'for': 'ruby' }
Plug 'tpope/vim-rake', { 'for': ['ruby', 'eruby'] }
Plug 'tpope/vim-bundler', { 'for': ['ruby', 'eruby'] }
Plug 'thoughtbot/vim-rspec', { 'for': ['ruby', 'eruby'] }
" rails
Plug 'tpope/vim-rails', { 'for': ['ruby', 'eruby'] }
" latex
Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }
call plug#end()

filetype plugin indent on
