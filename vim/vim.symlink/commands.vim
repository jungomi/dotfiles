" Fzf files with a preview window
command! -bang -nargs=? -complete=dir FilesPreview
      \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

" Ripgrep search combined with fzf
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>),
  \   0,
  \   <bang>0)
