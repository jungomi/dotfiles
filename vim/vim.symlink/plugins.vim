set nocompatible
filetype off

call plug#begin('~/.vim/plugged')
Plug 'chriskempson/base16-vim'

Plug 'scrooloose/nerdtree'
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
Plug 'tpope/vim-rails'
Plug 'scrooloose/syntastic'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'bling/vim-airline'
Plug 'tpope/vim-dispatch'
Plug 'airblade/vim-gitgutter'
Plug 'plasticboy/vim-markdown'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-unimpaired'
Plug 'jelera/vim-javascript-syntax'
Plug 'ap/vim-css-color'
Plug 'elzr/vim-json'
Plug 'suan/vim-instant-markdown'
Plug 'mattn/webapi-vim'
Plug 'mattn/gist-vim'
Plug 'artur-shaik/vim-javacomplete2'
" Javascript syntax and indentation
Plug 'pangloss/vim-javascript'
" mustache and handlebars
Plug 'mustache/vim-mustache-handlebars'
Plug 'tpope/vim-projectionist'
" ruby
Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-rake'
Plug 'tpope/vim-bundler'
call plug#end()

filetype plugin indent on
