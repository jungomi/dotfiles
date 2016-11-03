" Open quickfix window that occupies the full width without switching to it.
function! OpenQuickfix()
  let win = winnr()
  botright copen
  if win != winnr()
    execute win . 'wincmd w'
  endif
endfunction

" Runs tests with the appropriate tool for the current filetype.
" All given parameters are passed to the underlying test framework.
" Example: RunTest('%', '--verbose') would run the tests for the current file
" with a verbose output.
function! RunTest(...)
  if &filetype == 'ruby'
    let command = 'bundle exec rake test'
  elseif &filetype =~# 'javascript'
    let command = 'yarn test'
  else
    echo 'No test command found for current filetype ' . &filetype
    return
  endif
  let args = empty(a:000) ? '' : ' -- ' . join(map(copy(a:000), 'expand(v:val)'))
  call OpenQuickfix()
  execute 'AsyncRun ' . command . args
  echo 'Running: ' . command . args
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
