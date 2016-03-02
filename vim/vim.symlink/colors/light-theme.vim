" A light theme based on base16 colourschemes
" Best used with light-theme.sh

" GUI color definitions
let gui00 = "ffffdf"  " BG
let gui01 = "585858"  " Border
let gui02 = "ffdf5f"  " Visual select
let gui03 = "9e9e9e"  " Comment
let gui04 = "a09f93"  " PMenu
let gui05 = "555d60"  " Normal FG
let gui06 = "e8e6df"  " unused
let gui07 = "f2f0ec"  " White - unused
let gui08 = "d75f5f"  " Red
let gui09 = "d78700"  " Orange
let gui0A = "b58900"  " Yellow
let gui0B = "5faf5f"  " Green
let gui0C = "6887ee"  " Bright Blue
let gui0D = "5f87d7"  " Blue
let gui0E = "af5faf"  " Magenta
let gui0F = "d27b53"  " Brown
let guiColumnBg = "b2b2b2"
let guiWhite = "c6c6c6"
let guiBlack = "121212"
let guiCursorLine = "dfdfaf"
let guiCursor = "666666"
let guiDiffAdd = "dfffaf"
let guiDiffChange = "87afd7"
let guiDiffDelete = "ffdfdf"

" Terminal color definitions
let cterm00 = "230"   " BG
let cterm01 = "240"   " Border
let cterm02 = "221"   " Visual select
let cterm03 = "245"   " Comment
let cterm04 = "20"    " PMenu
let cterm05 = "240"   " Normal FG
let cterm06 = "21"    " unused
let cterm07 = "15"    " White - unused
let cterm08 = "167"   " Red
let cterm09 = "172"   " Orange
let cterm0A = "136"   " Yellow
let cterm0B = "71"    " Green
let cterm0C = "68"    " Bright Blue
let cterm0D = "68"    " Blue
let cterm0E = "133"   " Magenta
let cterm0F = "17"    " Brown
let ctermColumnBg = "249"
let ctermWhite = "251"
let ctermBlack = "233"
let ctermCursorLine = "187"
let ctermCursor = "242"
let ctermDiffAdd = "193"
let ctermDiffChange = "110"
let ctermDiffDelete = "224"

" Theme setup
hi clear
syntax reset
let g:colors_name = "light-theme"
set background=light

" Highlighting function
fun! <sid>hi(group, guifg, guibg, ctermfg, ctermbg, attr)
  if a:guifg != ""
    exec "hi " . a:group . " guifg=#" . a:guifg
  endif
  if a:guibg != ""
    exec "hi " . a:group . " guibg=#" . a:guibg
  endif
  if a:ctermfg != ""
    exec "hi " . a:group . " ctermfg=" . a:ctermfg
  endif
  if a:ctermbg != ""
    exec "hi " . a:group . " ctermbg=" . a:ctermbg
  endif
  if a:attr != ""
    exec "hi " . a:group . " gui=" . a:attr . " cterm=" . a:attr
  endif
endfun

" Vim editor colors
call <sid>hi("Bold",          "", "", "", "", "bold")
call <sid>hi("Debug",         gui08, "", cterm08, "", "")
call <sid>hi("Directory",     gui0D, "", cterm0D, "", "")
call <sid>hi("Error",         gui03, "", cterm03, "", "")
call <sid>hi("ErrorMsg",      gui08, gui00, cterm08, cterm00, "")
call <sid>hi("Exception",     gui08, "", cterm08, "", "")
call <sid>hi("FoldColumn",    guiWhite, gui01, ctermWhite, cterm01, "")
call <sid>hi("Folded",        gui05, guiWhite, cterm05, ctermWhite, "")
call <sid>hi("IncSearch",     gui01, gui09, cterm01, cterm09, "none")
call <sid>hi("Italic",        "", "", "", "", "none")
call <sid>hi("Macro",         gui08, "", cterm08, "", "")
call <sid>hi("MatchParen",    gui00, gui03, cterm00, cterm03,  "")
call <sid>hi("ModeMsg",       gui0B, "", cterm0B, "", "")
call <sid>hi("MoreMsg",       gui0B, "", cterm0B, "", "")
call <sid>hi("Question",      gui0D, "", cterm0D, "", "")
call <sid>hi("Search",        "", gui02, "", cterm02,  "")
call <sid>hi("SpecialKey",    gui03, "", cterm03, "", "")
call <sid>hi("TooLong",       gui08, "", cterm08, "", "")
call <sid>hi("Underlined",    gui08, "", cterm08, "", "")
call <sid>hi("Visual",        "", gui02, "", cterm02, "")
call <sid>hi("VisualNOS",     gui08, "", cterm08, "", "")
call <sid>hi("WarningMsg",    gui08, "", cterm08, "", "")
call <sid>hi("WildMenu",      gui08, "", cterm08, "", "")
call <sid>hi("Title",         gui0D, "", cterm0D, "", "none")
call <sid>hi("Conceal",       gui0D, gui00, cterm0D, cterm00, "")
call <sid>hi("Cursor",        "", guiCursor, "", ctermCursor, "none")
call <sid>hi("NonText",       gui03, "", cterm03, "", "")
call <sid>hi("Normal",        gui05, gui00, cterm05, cterm00, "")
call <sid>hi("LineNr",        gui03, gui01, cterm03, cterm01, "")
call <sid>hi("SignColumn",    gui03, gui01, cterm03, cterm01, "")
call <sid>hi("SpecialKey",    gui03, "", cterm03, "", "")
call <sid>hi("StatusLine",    guiWhite, guiBlack, ctermWhite, ctermBlack, "none")
call <sid>hi("StatusLineNC",  gui03, gui01, cterm03, cterm01, "none")
call <sid>hi("VertSplit",     gui0F, "", cterm0F, "", "none")
call <sid>hi("ColorColumn",   "", guiColumnBg, "", ctermColumnBg, "none")
call <sid>hi("CursorColumn",  "", guiCursorLine, "", ctermCursorLine, "none")
call <sid>hi("CursorLine",    "", guiCursorLine, "", ctermCursorLine, "none")
call <sid>hi("CursorLineNr",  gui03, gui01, cterm03, cterm01, "")
call <sid>hi("PMenu",         gui04, gui01, cterm04, cterm01, "none")
call <sid>hi("PMenuSel",      gui01, guiColumnBg, cterm01, ctermColumnBg, "")
call <sid>hi("TabLine",       gui03, gui01, cterm03, cterm01, "none")
call <sid>hi("TabLineFill",   gui03, gui01, cterm03, cterm01, "none")
call <sid>hi("TabLineSel",    gui01, gui0F, cterm01, cterm0F, "none")

" Standard syntax highlighting
call <sid>hi("Boolean",      gui09, "", cterm09, "", "")
call <sid>hi("Character",    gui08, "", cterm08, "", "")
call <sid>hi("Comment",      gui03, "", cterm03, "", "")
call <sid>hi("Conditional",  gui0E, "", cterm0E, "", "")
call <sid>hi("Constant",     gui09, "", cterm09, "", "")
call <sid>hi("Define",       gui0E, "", cterm0E, "", "none")
call <sid>hi("Delimiter",    gui0F, "", cterm0F, "", "")
call <sid>hi("Float",        gui09, "", cterm09, "", "")
call <sid>hi("Function",     gui0D, "", cterm0D, "", "")
call <sid>hi("Identifier",   gui08, "", cterm08, "", "none")
call <sid>hi("Include",      gui0D, "", cterm0D, "", "")
call <sid>hi("Keyword",      gui0E, "", cterm0E, "", "")
call <sid>hi("Label",        gui0A, "", cterm0A, "", "")
call <sid>hi("Number",       gui09, "", cterm09, "", "")
call <sid>hi("Operator",     gui05, "", cterm05, "", "none")
call <sid>hi("PreProc",      gui0A, "", cterm0A, "", "")
call <sid>hi("Repeat",       gui0A, "", cterm0A, "", "")
call <sid>hi("Special",      gui0C, "", cterm0C, "", "")
call <sid>hi("SpecialChar",  gui0F, "", cterm0F, "", "")
call <sid>hi("Statement",    gui08, "", cterm08, "", "")
call <sid>hi("StorageClass", gui0A, "", cterm0A, "", "")
call <sid>hi("String",       gui0B, "", cterm0B, "", "")
call <sid>hi("Structure",    gui0E, "", cterm0E, "", "")
call <sid>hi("Tag",          gui0A, "", cterm0A, "", "")
call <sid>hi("Todo",         gui01, gui0D, cterm01, cterm02, "none")
call <sid>hi("Type",         gui0A, "", cterm0A, "", "none")
call <sid>hi("Typedef",      gui0A, "", cterm0A, "", "")

" C highlighting
call <sid>hi("cOperator",   gui0C, "", cterm0C, "", "")
call <sid>hi("cPreCondit",  gui0E, "", cterm0E, "", "")

" CSS highlighting
call <sid>hi("cssBraces",      gui05, "", cterm05, "", "")
call <sid>hi("cssClassName",   gui0E, "", cterm0E, "", "")
call <sid>hi("cssColor",       gui0C, "", cterm0C, "", "")

" Diff highlighting
call <sid>hi("DiffAdd",      gui0B, guiDiffAdd,  cterm0B, ctermDiffAdd, "")
call <sid>hi("DiffChange",   gui05, guiDiffChange,  cterm05, ctermDiffChange, "")
call <sid>hi("DiffDelete",   gui08, guiDiffDelete,  cterm08, ctermDiffDelete, "")
call <sid>hi("DiffText",     gui0D, guiDiffChange,  cterm0D, ctermDiffChange, "")
call <sid>hi("DiffAdded",    gui0B, gui00,  cterm0B, cterm00, "")
call <sid>hi("DiffFile",     gui08, gui00,  cterm08, cterm00, "")
call <sid>hi("DiffNewFile",  gui0B, gui00,  cterm0B, cterm00, "")
call <sid>hi("DiffLine",     gui0D, gui00,  cterm0D, cterm00, "")
call <sid>hi("DiffRemoved",  gui08, gui00,  cterm08, cterm00, "")

" Git highlighting
call <sid>hi("gitCommitOverflow",  gui08, "", cterm08, "", "")
call <sid>hi("gitCommitSummary",   gui0B, "", cterm0B, "", "")
  
" GitGutter highlighting
call <sid>hi("GitGutterAdd",     gui0B, gui01, cterm0B, cterm01, "")
call <sid>hi("GitGutterChange",  gui0D, gui01, cterm0D, cterm01, "")
call <sid>hi("GitGutterDelete",  gui08, gui01, cterm08, cterm01, "")
call <sid>hi("GitGutterChangeDelete",  gui0E, gui01, cterm0E, cterm01, "")

" HTML highlighting
call <sid>hi("htmlBold",    gui0A, "", cterm0A, "", "")
call <sid>hi("htmlItalic",  gui0E, "", cterm0E, "", "")
call <sid>hi("htmlEndTag",  gui05, "", cterm05, "", "")
call <sid>hi("htmlTag",     gui05, "", cterm05, "", "")

" JavaScript highlighting
call <sid>hi("javaScript",        gui05, "", cterm05, "", "")
call <sid>hi("javaScriptBraces",  gui05, "", cterm05, "", "")
call <sid>hi("javaScriptNumber",  gui09, "", cterm09, "", "")

" Markdown highlighting
call <sid>hi("markdownCode",              gui0B, "", cterm0B, "", "")
call <sid>hi("markdownError",             gui05, gui00, cterm05, cterm00, "")
call <sid>hi("markdownCodeBlock",         gui0B, "", cterm0B, "", "")
call <sid>hi("markdownHeadingDelimiter",  gui0D, "", cterm0D, "", "")

" NERDTree highlighting
call <sid>hi("NERDTreeDirSlash",  gui0D, "", cterm0D, "", "")
call <sid>hi("NERDTreeExecFile",  gui05, "", cterm05, "", "")

" PHP highlighting
call <sid>hi("phpMemberSelector",  gui05, "", cterm05, "", "")
call <sid>hi("phpComparison",      gui05, "", cterm05, "", "")
call <sid>hi("phpParent",          gui05, "", cterm05, "", "")

" Python highlighting
call <sid>hi("pythonOperator",  gui0E, "", cterm0E, "", "")
call <sid>hi("pythonRepeat",    gui0E, "", cterm0E, "", "")

" Quickfix
call <sid>hi("qfLineNr", "", "", "", "", "")
call <sid>hi("qfError",  gui08, "", cterm08, "", "")

" Ruby highlighting
call <sid>hi("rubyAttribute",               gui0D, "", cterm0D, "", "")
call <sid>hi("rubyConstant",                gui0A, "", cterm0A, "", "")
call <sid>hi("rubyInterpolation",           gui0B, "", cterm0B, "", "")
call <sid>hi("rubyInterpolationDelimiter",  gui0F, "", cterm0F, "", "")
call <sid>hi("rubyRegexp",                  gui0C, "", cterm0C, "", "")
call <sid>hi("rubySymbol",                  gui0B, "", cterm0B, "", "")
call <sid>hi("rubyStringDelimiter",         gui0B, "", cterm0B, "", "")

" SASS highlighting
call <sid>hi("sassidChar",     gui08, "", cterm08, "", "")
call <sid>hi("sassClassChar",  gui09, "", cterm09, "", "")
call <sid>hi("sassInclude",    gui0E, "", cterm0E, "", "")
call <sid>hi("sassMixing",     gui0E, "", cterm0E, "", "")
call <sid>hi("sassMixinName",  gui0D, "", cterm0D, "", "")

" Signify highlighting
call <sid>hi("SignifySignAdd",     gui0B, gui01, cterm0B, cterm01, "")
call <sid>hi("SignifySignChange",  gui0D, gui01, cterm0D, cterm01, "")
call <sid>hi("SignifySignDelete",  gui08, gui01, cterm08, cterm01, "")

" Spelling highlighting
call <sid>hi("SpellBad",     "", gui00, "", cterm00, "undercurl")
call <sid>hi("SpellLocal",   "", gui00, "", cterm00, "undercurl")
call <sid>hi("SpellCap",     "", gui00, "", cterm00, "undercurl")
call <sid>hi("SpellRare",    "", gui00, "", cterm00, "undercurl")

" Syntastic
call <sid>hi("SyntasticErrorSign",    gui08, gui01, cterm08, cterm01, "")
call <sid>hi("SyntasticWarningSign",  gui02, gui01, cterm02, cterm01, "")

" Remove functions
delf <sid>hi

" Remove color variables
unlet gui00 gui01 gui02 gui03 gui04 gui05 gui06 gui07 gui08 gui09 gui0A gui0B gui0C gui0D gui0E gui0F guiColumnBg guiWhite guiBlack guiCursorLine guiCursor
unlet cterm00 cterm01 cterm02 cterm03 cterm04 cterm05 cterm06 cterm07 cterm08 cterm09 cterm0A cterm0B cterm0C cterm0D cterm0E cterm0F ctermColumnBg ctermWhite ctermBlack ctermCursorLine ctermCursor
