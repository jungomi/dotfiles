" Open quickfix window that occupies the full width without switching to it.
function! OpenQuickfix()
  let win = winnr()
  botright copen
  if win != winnr()
    execute win . 'wincmd w'
  endif
endfunction

" Run all tests
function! RunTestAll()
  if &filetype == 'ruby'
    call OpenQuickfix()
    AsyncRun bundle exec rake test
  elseif &filetype =~# 'javascript'
    call OpenQuickfix()
    AsyncRun yarn test
  endif
endfunction

" Run the tests in the current file
function! RunTestCurrent()
  if &filetype == 'ruby'
    call OpenQuickfix()
    AsyncRun bundle exec rake test TEST='%'
  elseif &filetype =~# 'javascript'
    call OpenQuickfix()
    AsyncRun yarn test %
  endif
endfunction

" Taken from https://www.reddit.com/r/vim/comments/e19bu/whats_your_status_line/
" Shows [trailing] if trailing white space is detected
function! StatuslineTrailingSpaceWarning()
  if !exists("b:statusline_trailing_space_warning")
    if search('\s\+$', 'nw') != 0
      let b:statusline_trailing_space_warning = '[trailing]'
    else
      let b:statusline_trailing_space_warning = ''
    endif
  endif
  return b:statusline_trailing_space_warning
endfunction

" Taken from https://www.reddit.com/r/vim/comments/e19bu/whats_your_status_line/
" Shows [&et] if &et is set wrong
" Shows [mixed-indenting] if spaces and tabs are used to indent
function! StatuslineTabWarning()
  if !exists("b:statusline_tab_warning")
    let tabs = search('^\t', 'nw') != 0
    let spaces = search('^ ', 'nw') != 0

    if tabs && spaces
      let b:statusline_tab_warning =  '[mixed-indenting]'
    elseif (spaces && !&et) || (tabs && &et)
      let b:statusline_tab_warning = '[&et]'
    else
      let b:statusline_tab_warning = ''
    endif
  endif
  return b:statusline_tab_warning
endfunction

" Taken from http://vimcasts.org/episodes/tidying-whitespace/
function! StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
