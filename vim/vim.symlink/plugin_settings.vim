" ⚑ Buftabline
let g:buftabline_indicators = 1
let g:buftabline_numbers = 1

" ⚑ JavaScript
let g:javascript_plugin_flow = 1
let g:javascript_plugin_jsdoc = 1

" ⚑ Flow
let g:flow#enable = 0

" ⚑ JSON
" Disable concealing json
let g:vim_json_syntax_conceal = 0

" ⚑ JSX
" Enable for all javascript files
let g:jsx_ext_required = 0

" ⚑ Emmet
let g:user_emmet_leader_key = '<C-E>'
let g:user_emmet_mode = 'i'

" ⚑ Undotree
let g:undotree_SetFocusWhenToggle = 1

" ⚑ Markdown
let g:markdown_fenced_languages = [
      \ 'html', 'python', 'bash=sh', 'ruby', 'javascript', 'js=javascript',
      \ 'sh', 'css', 'json', 'vim', 'ocaml', 'rust', 'go', 'haskell'
      \]

" ⚑ MdnQuery
let g:mdnquery_show_on_invoke = 1
let g:mdnquery_size = 15

" ⚑ EditorConfig
let g:EditorConfig_exclude_patterns = ['fugitive://.*']

" ⚑ Go
" Enable all highlighting
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
" Fmt only when called and suppress useless error message
let g:go_fmt_fail_silently = 1
let g:go_fmt_autosave = 0

" ⚑ Elm
" Format only when called and suppress useless error message
let g:elm_format_fail_silently = 1
let g:elm_format_autosave = 0
" Show type signatures in completion menu
let g:elm_detailed_complete = 1

" ⚑ Signify
let g:signify_vcs_list = ['git']
let g:signify_sign_change = '~'

" ⚑ R
" The terminal should be highlighted as if it were a R file
let R_hl_term = 1
let rout_follow_colorscheme = 1
let Rout_more_colors = 1
" Show .Rout file in a split, not tab
let R_routnotab = 1
let R_objbr_w = 80

" ⚑ Interactive REPL
let cmdline_follow_colorscheme = 1
let cmdline_app = {
      \ 'python': 'ipython'
      \ }
" Run in a Tmux pane instead of a terminal buffer
let g:cmdline_in_buffer = 0
let cmdline_map_send = '<LocalLeader><Space>'
let cmdline_map_send_and_stay = '<LocalLeader>l'

" ⚑ JsDoc
" Make it work with arrow functions
let g:jsdoc_enable_es6 = 1

" ⚑ COC
" Completion, LSP and various other niceties.
" Works generally better than standalone Vim plugins, since those are extensions
" also used in VSCode, and those are especially great for completions.
" Also just seems a lot cleaner and having those in one place is great.
" The extensions listed here are automatically installed by Coc.
let g:coc_global_extensions = [
      \ 'coc-html',
      \ 'coc-css',
      \ 'coc-json',
      \ 'coc-yaml',
      \ 'coc-tsserver',
      \ 'coc-git',
      \ 'coc-rls',
      \ 'coc-python',
      \ 'coc-snippets',
      \ 'coc-highlight',
      \ 'coc-prettier',
      \ 'coc-eslint',
      \ ]
" Jumping between placeholders for snippets.
let g:coc_snippet_prev = '<c-h>'
let g:coc_snippet_next = '<c-l>'

" Use default settings for fzf window (removes reverse)
let g:coc_fzf_opts = []

" Use floating window for Fzf when in NeoVim.
" Vim will fallback to the regular Fzf layout.
if has('nvim')
  let g:fzf_layout = { 'window': 'call FzfFloatingWin()' }
end
