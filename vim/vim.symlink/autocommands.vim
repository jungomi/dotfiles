if has('autocmd')
  augroup config_filetype
    autocmd!
    " ⚑ File type settings
    " Disable comment continuation when using 'o' or 'O'
    autocmd FileType * setlocal formatoptions-=o
    " Enable java completion
    autocmd FileType java setlocal omnifunc=javacomplete#Complete
    " Activate spell checking for relevant files
    autocmd FileType gitcommit,markdown,tex setlocal spell
    " Use tags from ~/.tags/<filetype>
    autocmd FileType * exec "setlocal tags+=~/.tags/" . &filetype
    " MdnQuery buffer <Tab> switches back to previous buffer
    autocmd FileType mdnquery nnoremap <buffer> <Tab> <C-w>p
    autocmd FileType mdnquery nnoremap <buffer> q :MdnQueryToggle<CR>

    " ⚑ Tab settings
    autocmd FileType python setlocal shiftwidth=4 textwidth=88 softtabstop=4 expandtab
    autocmd FileType make setlocal ts=8 sts=8 sw=8 noexpandtab
  augroup END

  augroup config_buffer
    autocmd!
    " ⚑ Pane settings
    " Resize panes when resizing window
    autocmd VimResized * wincmd =

    " ⚑ Buffer settings
    " Recognise markdown files properly
    autocmd BufRead,BufNewFile *.md setlocal filetype=markdown
    " Eslint without extension should be JSON
    autocmd BufRead,BufNewFile .babelrc,.eslintrc setlocal filetype=json
    " Refresh statusline indicators
    autocmd BufRead,BufWritePost * unlet! b:statusline_trailing_space_warning
    autocmd BufRead,BufWritePost * unlet! b:statusline_tab_warning
    " Close location list when the associated buffer is closed
    autocmd QuitPre * if empty(&buftype) | lclose | endif
    " Close location list when buffer is no longer visible
    autocmd BufWinLeave * lclose
    " Refresh diff signs after closing a git buffer
    autocmd BufWinLeave .git/* SignifyRefresh
  augroup END
endif
