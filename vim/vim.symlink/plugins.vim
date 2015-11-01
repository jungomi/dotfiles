filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" let Vundle manage Vundle
Plugin 'VundleVim/Vundle.vim'

Plugin 'chriskempson/base16-vim'

Plugin 'scrooloose/nerdtree'
Plugin 'mileszs/ack.vim'
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'garbas/vim-snipmate'
Plugin 'honza/vim-snippets'
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-fugitive'
Plugin 'sjl/gundo.vim', {'ŕtp': 'plugin/'}
Plugin 'godlygeek/tabular'
Plugin 'tpope/vim-rails'
Plugin 'scrooloose/syntastic'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'bling/vim-airline'
Plugin 'tpope/vim-dispatch'
Plugin 'airblade/vim-gitgutter'
Plugin 'plasticboy/vim-markdown'
Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-unimpaired'
Plugin 'jelera/vim-javascript-syntax'
Plugin 'ap/vim-css-color'
Plugin 'elzr/vim-json'
Plugin 'suan/vim-instant-markdown'
Plugin 'mattn/webapi-vim'
Plugin 'mattn/gist-vim'
call vundle#end()

filetype plugin indent on
