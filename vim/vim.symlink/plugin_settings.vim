" === Buftabline ===
let g:buftabline_numbers = 1
let g:buftabline_indicators = 1

" Automatically toggle error list
let g:neomake_open_list = 2
let g:neomake_list_height = 5
let g:neomake_verbose = 0
let g:neomake_warning_sign = {
  \ 'text': '⚑',
  \ 'texthl': 'SyntasticWarningSign',
  \ }

" === Gitgutter ===
let g:gitgutter_map_keys = 0

" === CtrlP ===
let g:ctrlp_map = '<leader>f'
let g:ctrlp_cmd = 'CtrlP'
" Ignore some folders and files for CtrlP indexing
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\.git$\|\.sass-cache$|\.hg$\|\.svn$\|\.yardoc\|public$|log\|tmp$\|node_modules$',
  \ 'file': '\.so$\|\.dat$'
  \ }

" === NERDTree ===
let NERDTreeShowBookmarks = 1
let NERDTreeIgnore = [
  \ '\.pyc', '\~$', '\.swo$', '\.swp$', '\.git$', '\.hg$', '\.svn$', '\.bzr$'
  \ ]
let NERDTreeShowHidden = 1
" Never change working directory
let NERDTreeChDirMode = 0

" === JSON ===
" Disable concealing json
let g:vim_json_syntax_conceal = 0

" === JSX ===
" Enable for all javascript files
let g:jsx_ext_required = 0

" === Emmet ===
let g:user_emmet_leader_key = '<C-E>'
let g:user_emmet_mode = 'i'

" === Projectionist ===
let g:projectionist_heuristics = {
  \   'package.json': {
  \     'src/components/*.js': {
  \       'type': "component",
  \       'alternate': "test/components/{}.spec.js"
  \     },
  \     'src/containers/*.js': {
  \       'type': 'container',
  \       'alternate': 'test/containers/{}.spec.js'
  \     },
  \     'src/actions/*.js': {
  \       'type': 'action',
  \       'alternate': 'test/actions/{}.spec.js'
  \     },
  \     'src/reducers/*.js': {
  \       'type': 'reducer',
  \       'alternate': 'test/reducers/{}.spec.js'
  \     },
  \     'src/naps/*.js': {
  \       'type': 'nap',
  \       'alternate': 'test/naps/{}.spec.js'
  \     },
  \     'test/*.spec.js': {
  \       'type': 'spec',
  \       'alternate': 'src/{}.js'
  \     }
  \   }
  \ }

" === Undotree ===
let g:undotree_DiffAutoOpen = 0
let g:undotree_SetFocusWhenToggle = 1
