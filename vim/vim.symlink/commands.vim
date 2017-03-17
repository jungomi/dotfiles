" Fzf files with a preview window
command! -bang -nargs=? -complete=dir FilesPreview
      \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
