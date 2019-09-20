if has('autocmd')
  augroup config_filetype
    autocmd!
    " ⚑ File type settings
    " Disable comment continuation when using 'o' or 'O'
    autocmd FileType * setlocal formatoptions-=o
    " Activate spell checking for relevant files
    autocmd FileType gitcommit,markdown,tex setlocal spell
    " Prevent some identing, liek if the previous line ended with a comma
    autocmd FileType gitcommit,markdown,tex,text,csv setlocal nocindent
    " Use tags from ~/.tags/<filetype>
    autocmd FileType * exec "setlocal tags+=~/.tags/" . &filetype
    " MdnQuery buffer <Tab> switches back to previous buffer
    autocmd FileType mdnquery nnoremap <buffer> <Tab> <C-w>p
    autocmd FileType mdnquery nnoremap <buffer> q :MdnQueryToggle<CR>
    " Disable colour column in quick fix window
    autocmd FileType qf setlocal colorcolumn=

    " ⚑ Tab settings
    autocmd FileType python setlocal shiftwidth=4 textwidth=88 softtabstop=4 expandtab
    autocmd FileType make setlocal ts=8 sts=8 sw=8 noexpandtab
    autocmd FileType csv setlocal noexpandtab
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
  augroup END

  augroup config_user
    " Show the signature when jumping through the arguments to a function, when
    " the function is inserted through the completion.
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  augroup END
endif
