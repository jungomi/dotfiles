" ⚑ Buftabline
let g:buftabline_numbers = 1
let g:buftabline_indicators = 1

" ⚑ Neomake
" Automatically toggle error list
let g:neomake_open_list = 2
let g:neomake_list_height = 5
let g:neomake_verbose = 0
let g:neomake_warning_sign = {
  \ 'text': '⚑',
  \ 'texthl': 'SyntasticWarningSign',
  \ }
" Ignore invalid entries (skips empty lines and summary)
let g:neomake_remove_invalid_entries = 1
" Makers
let g:neomake_javascript_enabled_makers = ['eslint', 'flow']
let g:neomake_jsx_enabled_makers = g:neomake_javascript_enabled_makers

" ⚑ Gitgutter
let g:gitgutter_map_keys = 0

" ⚑ CtrlP
let g:ctrlp_cmd = 'CtrlP'
" Ignore some folders and files for CtrlP indexing
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\.git$\|\.sass-cache$|\.hg$\|\.svn$\|\.yardoc\|public$|log\|tmp$\|node_modules$',
  \ 'file': '\.so$\|\.dat$'
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

" ⚑ Projectionist
let g:projectionist_heuristics = {
  \   'package.json': {
  \     'src/*.js': {
  \       'type': 'src',
  \       'alternate': "test/{}.test.js"
  \     },
  \     'lib/*.js': {
  \       'type': 'lib',
  \       'alternate': "test/{}.test.js"
  \     },
  \     'src/components/*.js': {
  \       'type': "component",
  \       'alternate': "test/components/{}.test.js"
  \     },
  \     'src/containers/*.js': {
  \       'type': 'container',
  \       'alternate': 'test/containers/{}.test.js'
  \     },
  \     'src/actions/*.js': {
  \       'type': 'action',
  \       'alternate': 'test/actions/{}.test.js'
  \     },
  \     'src/reducers/*.js': {
  \       'type': 'reducer',
  \       'alternate': 'test/reducers/{}.test.js'
  \     },
  \     'src/naps/*.js': {
  \       'type': 'nap',
  \       'alternate': 'test/naps/{}.test.js'
  \     },
  \     'test/*.test.js': {
  \       'type': 'test',
  \       'alternate': 'src/{}.js'
  \     },
  \     'test/*.spec.js': {
  \       'type': 'spec',
  \       'alternate': 'src/{}.js'
  \     }
  \   }
  \ }

" ⚑ Undotree
let g:undotree_DiffAutoOpen = 0
let g:undotree_SetFocusWhenToggle = 1

" ⚑ Markdown
let g:markdown_fenced_languages = [
      \ 'html', 'python', 'bash=sh', 'ruby', 'javascript', 'js=javascript',
      \ 'sh', 'css', 'json', 'vim'
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


" ⚑ JsDoc
" Make it work with arrow functions
let g:jsdoc_enable_es6 = 1
