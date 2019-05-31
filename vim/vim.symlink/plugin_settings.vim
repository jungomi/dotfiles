" ⚑ Buftabline
let g:buftabline_indicators = 1
let g:buftabline_numbers = 1

" ⚑ Ale
let g:ale_sign_error = '✖'
let g:ale_sign_warning = '⚑'
highlight link ALEWarningSign  SyntasticWarningSign
highlight link ALEErrorSign SyntasticErrorSign
let g:ale_echo_msg_format = '%linter%: %s'
let g:ale_lint_on_text_changed = 'never'
let g:ale_open_list = 'on_save'
let g:ale_rust_cargo_check_all_targets = 0
let g:ale_fixers = {
      \   'elm': ['format'],
      \   'go': ['gofmt'],
      \   'javascript': ['prettier'],
      \   'typescript': ['prettier'],
      \   'reason': ['refmt'],
      \   'rust': [{_ -> rustfmt#Format()}],
      \   'crystal': [{_ -> crystal_lang#format('')}],
      \ }
let g:ale_linters = {
      \   'go': ['go build'],
      \   'rust': ['rls'],
      \   'cpp': ['ccls']
      \ }
let g:ale_python_mypy_options = '--ignore-missing-imports'
let g:ale_cpp_ccls_init_options = {
      \   'cache': {
      \       'directory': '/tmp/ccls/cache',
      \   },
      \ }

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

" ⚑ LSP
let g:LanguageClient_autoStart = 1
" Show diagnostics in location list (each buffer has its own)
let g:LanguageClient_diagnosticsList = 'location'
" Disable the diagnostics/linting for now, as ALE does it better
let g:LanguageClient_diagnosticsEnable = 0
let g:LanguageClient_serverCommands = {
      \ 'rust': ['rls'],
      \ 'ocaml': ['ocaml-language-server', '--stdio'],
      \ 'reason': ['ocaml-language-server', '--stdio'],
      \ 'python': ['pyls'],
      \ 'r': ['R', '--slave', '-e', 'languageserver::run()'],
      \ 'cpp': ['ccls', '--log-file=/tmp/ccls.log', '--init={"cache":{"directory":"/tmp/ccls/cache"}}'],
      \ }
