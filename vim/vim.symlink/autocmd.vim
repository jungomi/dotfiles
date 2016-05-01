if has('autocmd') && !exists('autocommands_loaded')
  " Load autocommands only once
  let autocommands_loaded = 1

  " === File type settings ===
  " Disable comment continuation when using 'o' or 'O'
  autocmd FileType * setlocal formatoptions-=o
  " Syntax highlighting for C custom types
  autocmd FileType c syntax match cType "\<\w\+_t\>"
  " Enable java completion
  autocmd FileType java set omnifunc=javacomplete#Complete
  " Activate spell checking for relevant files
  autocmd FileType gitcommit,markdown,tex set spell

  " === Tab settings ===
  autocmd FileType python setlocal shiftwidth=4 softtabstop=4 expandtab
  autocmd FileType make setlocal ts=8 sts=8 sw=8 noexpandtab

  " === Pane settings ===
  " Resize panes when resizing window
  autocmd VimResized * wincmd =
  " Make quickfix windows take all the lower section of the screen when there
  " are multiple windows open
  autocmd FileType qf wincmd J

  " === Buffer settings ===
  " Recognise markdown files properly
  autocmd BufRead,BufNewFile *.md set filetype=markdown
  " Refresh trailing whitespace indicator
  autocmd BufRead,BufWritePost * unlet! b:statusline_trailing_space_warning
endif