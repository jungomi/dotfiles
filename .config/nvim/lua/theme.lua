local reset_highlight = require("utils.highlight").reset_highlight

local colours = {
  red = "#df5f5f",
  green = "#66b766",
  orange = "#e39a34",
  blue = "#5f87d7",
  purple = "#b169b1",
  cyan = "#52a6a5",
  yellow = "#ffd75f",
  grey = "#8e8e8e",
  pink = "#df6ea5",

  light_orange = "#f3bd49",
  light_grey = "#d3d0c8",
  light_red = "#ffdfdf",
  light_green = "#dfffaf",
  light_blue = "#eeeeee",

  dark_orange = "#f99157",

  fg = "#555d60",
  bg = "#fdf6e3",
  border = "#f4efd9",
  cursor_line = "#eee8d5",

  dark_grey = "#7a7a7a",
  dark_border = "#ddd5c1",
}

local theme = {
  base = {
    Normal = { fg = colours.fg },
    NormalFloat = { bg = colours.cursor_line },
    FloatBorder = { bg = colours.cursor_line, fg = colours.grey },
    FloatTitle = { bg = colours.cursor_line, fg = colours.blue, bold = true },
    VertSplit = { fg = colours.orange },
    WinSeparator = { fg = colours.orange },

    Cursor = { bg = colours.fg, fg = colours.bg },
    CursorLine = { bg = colours.cursor_line },
    CursorColumn = { bg = colours.cursor_line },
    ColorColumn = { bg = colours.light_grey },
    Visual = { bg = colours.yellow },
    VisualNOS = { bg = colours.light_orange },
    Search = { bg = colours.yellow },
    IncSearch = { bg = colours.orange, fg = colours.fg },
    CurSearch = { bg = colours.light_orange },
    Yank = { bg = colours.light_orange },
    SnippetTabstop = { bg = colours.cursor_line },

    LineNr = { bg = colours.border, fg = colours.grey },
    CursorLineNr = { bg = colours.border, fg = colours.fg, bold = true },
    SignColumn = { bg = colours.border, fg = colours.grey },
    FoldColumn = { bg = colours.border, fg = colours.grey },
    Folded = { bg = colours.border },
    qfLineNr = { fg = colours.purple, italic = true },

    TabLine = { bg = colours.border, fg = colours.grey },
    TabLineFill = { bg = colours.border, fg = colours.grey },
    TabLineSel = { bg = colours.purple, fg = colours.grey },

    StatusLine = { fg = colours.dark_grey, bg = colours.dark_border, bold = true },
    StatusLineNC = { fg = colours.grey, bg = colours.cursor_line },
    WinBar = { fg = colours.grey, bg = colours.cursor_line, bold = true },
    WinBarNC = { fg = colours.grey, bg = colours.border },

    PMenu = { bg = colours.cursor_line },
    PMenuSel = { bg = colours.yellow },
    PMenuSbar = { bg = colours.cursor_line },
    PMenuThumb = { bg = colours.grey },

    ErrorMsg = { fg = colours.red, bold = true },
    ModeMsg = { fg = colours.green, bold = true },
    MoreMsg = { fg = colours.blue, bold = true },
    WarningMsg = { fg = colours.orange, bold = true },
    Question = { fg = colours.blue, bold = true },
    Title = { fg = colours.blue, bold = true },
    Directory = { fg = colours.blue, bold = true },
    healthSuccess = { link = "ModeMsg" },

    Conceal = { fg = colours.dark_grey },
    MatchParen = { bg = colours.grey, fg = colours.bg },

    SpellBad = { undercurl = true },
    SpellCap = { undercurl = true },
    SpellLocal = { undercurl = true },
    SpellRare = { undercurl = true },
  },
  syntax = {
    Bold = { bold = true },
    Boolean = { fg = colours.dark_orange },
    Character = { fg = colours.dark_orange },
    Comment = { fg = colours.grey },
    Conditional = { fg = colours.purple },
    Constant = { fg = colours.dark_orange },
    Debug = { fg = colours.red },
    Define = { fg = colours.purple },
    Delimiter = { fg = colours.fg },
    Error = { fg = colours.red },
    Exception = { fg = colours.purple },
    Float = { fg = colours.dark_orange },
    Function = { fg = colours.blue },
    Identifier = { fg = colours.blue },
    Include = { fg = colours.blue },
    Italic = { italic = true },
    Keyword = { fg = colours.purple },
    Label = { fg = colours.orange },
    Macro = { fg = colours.red },
    Number = { fg = colours.dark_orange },
    NonText = { fg = colours.grey },
    Operator = { fg = colours.fg },
    PreProc = { fg = colours.blue },
    Repeat = { fg = colours.purple },
    Special = { fg = colours.cyan },
    SpecialChar = { fg = colours.orange },
    Statement = { fg = colours.purple },
    StorageClass = { fg = colours.orange },
    String = { fg = colours.green },
    Structure = { fg = colours.purple },
    Tag = { fg = colours.orange },
    Todo = { fg = colours.purple },
    Type = { fg = colours.orange },
    Typedef = { fg = colours.orange },
    Underlined = { underline = true },
  },
  treesitter = {
    -- Only groups that are not linked to the desired default, rest (mostly @xxx -> xxx) is skipped
    -- This now uses the tree sitter capture groups (@xxx) instead of prefixed ones such as TSxxx.
    -- e.g. @boolean -> Boolean (skipped)
    ["@conceal"] = { link = "Conceal" },
    ["@constant.builtin"] = { link = "Constant" },
    ["@constant.macro"] = { link = "Macro" },
    ["@constructor"] = { link = "Function" },
    ["@error"] = { link = "Error" },
    ["@field"] = { fg = colours.fg },
    ["@function.builtin"] = { link = "Function" },
    ["@include"] = { fg = colours.purple },
    ["@keyword.operator"] = { fg = colours.purple },
    ["@namespace"] = { fg = colours.purple },
    ["@parameter"] = { fg = colours.cyan },
    ["@property"] = { fg = colours.cyan },
    ["@symbol"] = { fg = colours.cyan },
    ["@variable"] = { fg = colours.fg },
    ["@variable.builtin"] = { link = "Constant" },
    ["@tag"] = { fg = colours.purple },
    -- Tags in comments, such as TODO or NOTE. Where @text.note is the generic (parent) group.
    ["@text.note"] = { fg = colours.cyan, bold = true },
    -- For some reason TODO is also a @text.warning instead of a separate entity.
    ["@text.warning"] = { fg = colours.purple, bold = true },
    ["@text.danger"] = { fg = colours.red, bold = true },
    -- These now look like real comment labels
    ["@comment.note"] = { fg = colours.cyan, bold = true },
    ["@comment.todo"] = { fg = colours.purple, bold = true },
    ["@comment.error"] = { fg = colours.red, bold = true },
    ["@comment.warning"] = { fg = colours.orange, bold = true },
    -- Diffs within Treesitter such as in git commits
    ["@text.diff.add"] = { fg = colours.green },
    ["@text.diff.delete"] = { fg = colours.red },
    ["@text.environment"] = { link = "@namespace" },
    ["@text.environment.name"] = { link = "Type" },
    ["@text.reference"] = { link = "Type" },
    ["@text.title"] = { link = "Title" },
    -- Special characters, such as in string interpolation
    ["@punctuation.special"] = { fg = colours.dark_grey, bold = true },

    -- :: Filetype specific (by adding the .extension at the end)
    ["@field.yaml"] = { fg = colours.red },
    ["@punctuation.special.markdown"] = { link = "@text.title" },
    ["@module.latex"] = { link = "@namespace" },
    ["@markup.link.latex"] = { link = "@label.latex" },
    ["@markup.link.label.markdown_inline"] = {},
    ["@attribute.diff"] = { link = "diffLine" },
    ["@module.python"] = {},
  },
  lsp = {
    -- Defaults (mostly for fallbacks)
    DiagnosticError = { fg = colours.red },
    DiagnosticWarn = { fg = colours.orange },
    DiagnosticInfo = { fg = colours.blue },
    DiagnosticHint = { fg = colours.cyan },
    DiagnosticOk = { fg = colours.green },

    -- Signs
    DiagnosticSignError = { fg = colours.red, bg = colours.border },
    DiagnosticSignWarn = { fg = colours.orange, bg = colours.border },
    DiagnosticSignInfo = { fg = colours.blue, bg = colours.border },
    DiagnosticSignHint = { fg = colours.cyan, bg = colours.border },
    DiagnosticSignOk = { fg = colours.green, bg = colours.border },

    -- Virtual text
    DiagnosticVirtualTextError = { fg = colours.red, italic = true },
    DiagnosticVirtualTextWarn = { fg = colours.orange, italic = true },
    DiagnosticVirtualTextInfo = { fg = colours.blue, italic = true },
    DiagnosticVirtualTextHint = { fg = colours.cyan, italic = true },
    DiagnosticVirtualTextOk = { fg = colours.green, italic = true },

    -- Floating window text
    DiagnosticFloatingError = { fg = colours.red },
    DiagnosticFloatingWarn = { fg = colours.orange },
    DiagnosticFloatingInfo = { fg = colours.blue },
    DiagnosticFloatingHint = { fg = colours.cyan },
    DiagnosticFloatingOk = { fg = colours.green },

    -- Underline the corresponding text
    DiagnosticUnderlineError = { undercurl = true, special = colours.red },
    DiagnosticUnderlineWarn = { undercurl = true, special = colours.orange },
    DiagnosticUnderlineInfo = { undercurl = true, special = colours.blue },
    DiagnosticUnderlineHint = { undercurl = true, special = colours.cyan },
    DiagnosticUnderlineOk = { undercurl = true, special = colours.cyan },

    -- Unused variables / imports
    DiagnosticUnnecessary = { fg = colours.grey, undercurl = true },

    -- Highlighting of References
    LspReferenceText = { bg = colours.cursor_line },
    LspReferenceRead = { bg = colours.cursor_line },
    LspReferenceWrite = { bg = colours.cursor_line },

    -- Signature popup
    LspSignatureActiveParameter = { link = "Search" },

    -- Inlay hints
    LspInlayHint = { fg = colours.grey, italic = true },

    -- Trouble
    TroubleNormal = { link = "Normal" },
    TroubleNormalNC = { link = "TroubleNormal" },
    TroubleIndent = { fg = colours.grey },
    TroubleCount = { fg = colours.grey, italic = true },
    TroubleFoldIcon = { fg = colours.grey },
    TroubleLocation = { fg = colours.purple, italic = true },
    TroublePos = { fg = colours.purple, italic = true },
    TroubleSignError = { fg = colours.red },
    TroubleSignWarning = { fg = colours.orange },
    TroubleSignInformation = { fg = colours.blue },
    TroubleSignHint = { fg = colours.cyan },
    TroubleSignOk = { fg = colours.green },

    -- Saga
    -- So many unnecessary border/line highlight groups
    LspSagaAutoPreview = { link = "FloatBorder" },
    LspSagaAutoPreviewBorder = { link = "FloatBorder" },
    LspSagaCodeActionBorder = { link = "FloatBorder" },
    LspSagaDefPreviewBorder = { link = "FloatBorder" },
    LspSagaDiagnosticBorder = { link = "FloatBorder" },
    LspSagaHoverBorder = { link = "FloatBorder" },
    LspSagaLspFinderBorder = { link = "FloatBorder" },
    LspSagaSignatureHelpBorder = { link = "FloatBorder" },
    LspSagaRenameBorder = { link = "FloatBorder" },
    LspSagaRenamePromptPrefix = { fg = colours.grey },
    LspSagaCodeActionTruncateLine = { link = "FloatBorder" },
    LspSagaDiagnosticTruncateLine = { link = "FloatBorder" },
    LspSagaDocTruncateLine = { link = "FloatBorder" },
    LspSagaShTruncateLine = { link = "FloatBorder" },
    LspSagaLightBulb = { fg = colours.light_orange },
    LspSagaLightBulbSign = { fg = colours.light_orange, bg = colours.border },
    LspSagaFinderSelection = { bg = colours.cursor_line },
    LspSagaCodeActionTitle = { fg = colours.grey, bold = true },
    LspSagaDiagnosticHeader = { fg = colours.grey, bold = true },
    LspSagaCodeActionContent = { fg = colours.grey },

    -- Cmp (Completion Menu)
    CmpItemAbbr = { fg = colours.grey },
    CmpItemAbbrMatch = { fg = colours.fg },
    CmpItemAbbrMatchFuzzy = { fg = colours.fg, italic = true },
    CmpItemKind = { fg = colours.grey },
    -- Name of source, e.g. [LSP]
    CmpItemMenu = { fg = colours.grey },

    -- Blink (Completion)
    BlinkCmpKind = { link = "CmpItemKind" },
    BlinkCmpLabel = { link = "CmpItemAbbr" },
    BlinkCmpLabelMatch = { link = "CmpItemAbbrMatch" },
    BlinkCmpLabelDeprecated = { fg = colours.grey, strikethrough = true },
    BlinkCmpLabelDetail = { fg = colours.cyan },
    BlinkCmpLabelDescription = { fg = colours.orange },
    BlinkCmpSource = { fg = colours.grey },

    -- :: Semantic tokens
    ["@lsp.type.attributeBracket"] = { link = "@punctuation.special" },
    ["@lsp.type.builtinAttribute"] = { link = "Identifier" },
    ["@lsp.type.enum"] = { link = "@type" },
    ["@lsp.type.enumMember"] = { link = "@property" },
    ["@lsp.type.interface"] = { link = "Macro" },
    ["@lsp.type.parameter"] = { link = "@parameter" },
    ["@lsp.type.property"] = { link = "@property" },
    ["@lsp.type.struct"] = { link = "Identifier" },
    ["@lsp.type.selfKeyword"] = { link = "Constant" },
    ["@lsp.type.typeAlias"] = { link = "@type" },
    -- Fallback to the treesitter highlighting for this.
    -- NOTE: This is not the same as linking it to @variable because treesitter might
    -- classify it differently based on some basic rules.
    -- e.g. all caps are Treesitter constants but an LSP variable, because LSP constants
    -- are the ones marked as const by the language (i.e. not supported by languages like Lua)
    ["@lsp.type.variable"] = {},
    ["@lsp.type.keyword.rust"] = { link = "Keyword" },
    -- Classes are mostly linked to Type because without semantic tokens, that's what they would be.
    -- So it's more about having the consistency, even though it might be helpful to distinguish them.
    ["@lsp.type.class.python"] = { link = "Type" },
    ["@lsp.type.namespace.python"] = {},
    -- Default library
    ["@lsp.typemod.enumMember.defaultLibrary"] = { link = "Constant" },
    ["@lsp.typemod.function.defaultLibrary"] = { link = "@function.builtin" },
    ["@lsp.typemod.method.defaultLibrary"] = { link = "@function.builtin" },
    ["@lsp.typemod.variable.defaultLibrary"] = { link = "@variable.builtin" },
    -- Mods
    ["@lsp.mod.crateRoot"] = { link = "Constant" },
    ["@lsp.mod.documentation"] = { link = "Special" },
    -- Not quite sure whether I want to add decorations for specific mods
    -- ["@lsp.mod.declaration"] = { italic = true },
    -- ["@lsp.mod.global"] = { bold = true },
  },
  bufferline = {
    -- Three for each kind, because there are three types of buffers with different backgrounds.
    -- The names are shortcuts to work around highlight groups counting towards length of the
    -- bufferline, because it counts the number of characters.
    -- E = Error, W = Warning, I = Information, H = Hint
    -- S = Selected, V = Visible, H = Hidden
    ES = { fg = colours.red, bg = colours.bg },
    EV = { fg = colours.red, bg = colours.cursor_line },
    EH = { fg = colours.red, bg = colours.dark_border },

    WS = { fg = colours.orange, bg = colours.bg },
    WV = { fg = colours.orange, bg = colours.cursor_line },
    WH = { fg = colours.orange, bg = colours.dark_border },

    IS = { fg = colours.blue, bg = colours.bg },
    IV = { fg = colours.blue, bg = colours.cursor_line },
    IH = { fg = colours.blue, bg = colours.dark_border },

    HS = { fg = colours.cyan, bg = colours.bg },
    HV = { fg = colours.cyan, bg = colours.cursor_line },
    HH = { fg = colours.cyan, bg = colours.dark_border },
  },
  git = {
    DiffAdd = { bg = colours.light_green },
    DiffChange = { bg = colours.light_blue },
    DiffDelete = { fg = colours.light_grey },
    DiffText = { fg = colours.blue, bg = colours.light_blue, bold = true },

    -- Colours in git commit messages
    gitcommitSummary = { fg = colours.green },
    gitcommitOverflow = { fg = colours.red },
    gitcommitHeader = { fg = colours.blue },
    -- Staged files
    gitcommitSelectedFile = { fg = colours.green },
    gitcommitSelectedType = { fg = colours.green, bold = true },
    -- Unstaged files
    gitcommitDiscardedFile = { fg = colours.orange },
    gitcommitDiscardedType = { fg = colours.orange, bold = true },
    -- Untracked files
    gitcommitUntrackedFile = { fg = colours.red },

    -- Diffs in git commits
    diffAdded = { fg = colours.green },
    diffRemoved = { fg = colours.red },
    diffLine = { fg = colours.purple },
    diffIndexLine = { fg = colours.blue },
    diffFile = { fg = colours.cyan },
    diffNewFile = { fg = colours.green },
    diffOldFile = { fg = colours.red },

    -- Same as above, not sure where these come from, but used in some diffs
    Added = { link = "diffAdded" },
    Removed = { link = "diffRemoved" },

    GitSignsAdd = { fg = colours.green, bg = colours.border },
    GitSignsChange = { fg = colours.blue, bg = colours.border },
    GitSignsDelete = { fg = colours.red, bg = colours.border },
    -- Inline word diffs
    GitSignsAddInline = { link = "DiffAdd" },
    GitSignsChangeInline = { link = "DiffText" },
    GitSignsDeleteInline = { bg = colours.light_red },
    GitSignsDeletePreview = { fg = colours.red },
    GitSignsDeleteVirtLn = { link = "GitSignsDeletePreview" },

    fugitiveHash = { fg = colours.red },
    fugitiveHeading = { link = "Title" },
    fugitiveSymbolicRef = { link = "Special" },
    fugitiveStagedHeading = { fg = colours.green, bold = true },
    fugitiveStagedModifier = { fg = colours.green },
    fugitiveUnstagedHeading = { fg = colours.orange, bold = true },
    fugitiveUnstagedModifier = { fg = colours.orange },
    fugitiveUntrackedHeading = { fg = colours.red, bold = true },
    fugitiveUntrackedModifier = { fg = colours.red },
  },
  dap = {
    DapUIBreakpointsPath = { link = "Directory" },
    DapUIBreakpointsInfo = { fg = colours.cyan },
    DapUIBreakpointsCurrentLine = { fg = colours.fg, bold = true },
    DapUIFloatBorder = { link = "FloatBorder" },
    DapUIFrameName = { fg = colours.purple },
    DapUIDecoration = { fg = colours.cyan },
    DapUILineNumber = { fg = colours.grey },
    DapUIScope = { link = "Title" },
    DapUISource = { link = "Directory" },
    DapUIStoppedThread = { fg = colours.red, bold = true },
    DapUIThread = { fg = colours.cyan, bold = true },
    DapUIType = { link = "Type" },
    DapUIVariable = { fg = colours.purple },
    DapUIModifiedValue = { fg = colours.cyan },
    DapUIWatchesEmpty = { fg = colours.grey },
    DapUIWatchesError = { fg = colours.red },
    DapUIWatchesValue = { fg = colours.cyan },

    -- Icons
    -- For some reason the background needs to be specified manually, otherwise it uses Normal as background,
    -- which is wrong as they should match the WinBar colours.
    DapUIPlayPause = { fg = colours.green, bg = colours.cursor_line },
    DapUIPlayPauseNC = { fg = colours.green, bg = colours.border },
    DapUIRestart = { fg = colours.green, bg = colours.cursor_line },
    DapUIRestartNC = { fg = colours.green, bg = colours.border },
    DapUIStepBack = { fg = colours.blue, bg = colours.cursor_line },
    DapUIStepBackNC = { fg = colours.blue, bg = colours.border },
    DapUIStepInto = { fg = colours.blue, bg = colours.cursor_line },
    DapUIStepIntoNC = { fg = colours.blue, bg = colours.border },
    DapUIStepOut = { fg = colours.blue, bg = colours.cursor_line },
    DapUIStepOutNC = { fg = colours.blue, bg = colours.border },
    DapUIStepOver = { fg = colours.blue, bg = colours.cursor_line },
    DapUIStepOverNC = { fg = colours.blue, bg = colours.border },
    DapUIStop = { fg = colours.red, bg = colours.cursor_line },
    DapUIStopNC = { fg = colours.red, bg = colours.border },
    DapUIUnavailable = { fg = colours.grey, bg = colours.cursor_line },
    DapUIUnavailableNC = { fg = colours.grey, bg = colours.border },

    NvimDapVirtualText = { fg = colours.grey, italic = true },
    NvimDapVirtualTextChanged = { link = "DiagnosticVirtualTextWarn" },
    NvimDapVirtualTextError = { link = "DiagnosticVirtualTextError" },
    NvimDapVirtualTextInfo = { link = "DiagnosticVirtualTextInfo" },

    -- Custom statusline for dap-ui (not part of the plugin)
    DapUIStatusline = { fg = colours.grey, bg = colours.bg, bold = true },
  },
  markdown = {
    markdownCode = { link = "String" },
    markdownCodeDelimiter = { fg = colours.grey, bold = true },
    markdownLinkText = { link = "Special" },
    markdownListMarker = { fg = colours.cyan, bold = true },
    markdownUrl = { fg = colours.dark_grey },

    markdownH1Delimiter = { link = "markdownH1" },
    markdownH2Delimiter = { link = "markdownH2" },
    markdownH3Delimiter = { link = "markdownH3" },
    markdownH4Delimiter = { link = "markdownH4" },
    markdownH5Delimiter = { link = "markdownH5" },
    markdownH6Delimiter = { link = "markdownH6" },
  },
  markview = {
    MarkviewHeading1 = { link = "markdownH1" },
    MarkviewHeading2 = { link = "markdownH2" },
    MarkviewHeading3 = { link = "markdownH3" },
    MarkviewHeading4 = { link = "markdownH4" },
    MarkviewHeading5 = { link = "markdownH5" },
    MarkviewHeading6 = { link = "markdownH6" },

    MarkviewIcon1 = { fg = colours.dark_grey, bg = colours.dark_border },
    MarkviewIcon2 = { link = "MarkviewIcon1" },
    MarkviewIcon3 = { link = "MarkviewIcon1" },
    MarkviewIcon4 = { link = "MarkviewIcon1" },
    MarkviewIcon5 = { link = "MarkviewIcon1" },
    MarkviewIcon6 = { link = "MarkviewIcon1" },

    MarkviewIcon1Sign = { bg = colours.border, fg = colours.dark_grey },
    MarkviewIcon2Sign = { link = "MarkviewIcon1Sign" },
    MarkviewIcon3Sign = { link = "MarkviewIcon1Sign" },
    MarkviewIcon4Sign = { link = "MarkviewIcon1Sign" },
    MarkviewIcon5Sign = { link = "MarkviewIcon1Sign" },
    MarkviewIcon6Sign = { link = "MarkviewIcon1Sign" },

    MarkviewCode = { link = "CursorLine" },
    MarkviewInlineCode = { link = "MarkviewCode" },
    MarkviewCodeInfo = { link = "MarkviewIcon1" },

    MarkviewListItemMinus = { link = "markdownListMarker" },
    MarkviewListItemPlus = { link = "MarkviewListItemMinus" },
    MarkviewListItemStar = { link = "MarkviewListItemMinus" },

    MarkviewBlockQuoteOk = { link = "DiagnosticOk" },
    MarkviewBlockQuoteNote = { link = "DiagnosticInfo" },
    MarkviewBlockQuoteWarn = { link = "DiagnosticWarn" },
    MarkviewBlockQuoteError = { link = "DiagnosticError" },
    MarkviewBlockQuoteSpecial = { fg = colours.purple },

    MarkviewDiffAdd = { bg = colours.light_green },
    MarkviewDiffDelete = { bg = colours.light_red },
  },
  notify = {
    NotifyINFOTitle = { link = "ModeMsg" },
    NotifyWARNTitle = { link = "DiagnosticWarn" },
    NotifyERRORTitle = { link = "DiagnosticError" },
    NotifyTRACETitle = { link = "DiagnosticHint" },

    NotifyINFOIcon = { link = "NotifyINFOTitle" },
    NotifyWARNIcon = { link = "NotifyWARNTitle" },
    NotifyERRORIcon = { link = "NotifyERRORTitle" },
    NotifyTRACEIcon = { link = "NotifyTRACETitle" },
  },
  noice = {
    NoiceCmdlineIcon = { link = "DiagnosticInfo" },
    NoiceCmdlineIconSearch = { link = "DiagnosticWarn" },

    NoiceCmdlinePopup = { link = "NormalFloat" },
    NoiceCmdlinePopupBorder = { link = "NoiceCmdlineIcon" },
    NoiceCmdlinePopupBorderSearch = { link = "NoiceCmdlineIconSearch" },
    NoiceConfirm = { link = "NormalFloat" },
    NoiceConfirmBorder = { link = "NoiceCmdlinePopupBorder" },
    NoiceFormatConfirm = { link = "LazyButton" },

    NoiceMini = { fg = colours.grey, bg = colours.cursor_line },
    NoiceFormatProgressDone = { fg = colours.grey, bg = colours.dark_border, bold = true },
    NoiceFormatProgressTodo = { fg = colours.dark_border, bold = true },
    NoiceLspProgressTitle = { fg = colours.grey },
    NoiceLspProgressSpinner = { fg = colours.grey, bold = true },

    NoiceSplit = { link = "Normal" },
  },
  -- Floating Winbar showing buffer name at the top right of the window
  incline = {
    InclineNormal = { link = "WinBar" },
    InclineNormalNC = { link = "WinBarNC" },
  },
  -- Scrollbar
  scrollview = {
    Scrollview = { bg = colours.dark_border },

    -- Signs
    ScrollViewDiagnosticsError = { link = "DiagnosticError" },
    ScrollViewDiagnosticsWarn = { link = "DiagnosticWarn" },
    ScrollViewDiagnosticsInfo = { link = "DiagnosticInfo" },
    ScrollViewDiagnosticsHint = { link = "DiagnosticHint" },
    ScrollViewSearch = { fg = colours.orange },
    ScrollViewMarks = { fg = colours.orange, italic = true },
  },
  which_key = {
    WhichKey = { link = "Special" },
  },
  telescope = {
    TelescopeResultsDiffAdd = { fg = colours.green, bold = true },
    TelescopeResultsDiffChange = { fg = colours.orange, bold = true },
    TelescopeResultsDiffDelete = { fg = colours.red, bold = true },
    TelescopeResultsDiffUntracked = { fg = colours.red },
  },
  fzf = {
    FzfLuaHeaderText = { link = "Comment" },
    FzfLuaHeaderBind = { link = "Special" },
    FzfLuaBufName = { link = "Statement" },
    FzfLuaBufNr = { link = "Comment" },
    FzfLuaPathLineNr = { link = "Special" },
    FzfLuaTabMarker = { link = "Special" },
    FzfLuaBorder = { link = "WinBar" },
    FzfLuaPreviewTitle = { link = "WinBar" },
    FzfLuaHelpNormal = { link = "CursorLine" },
  },
  flash = {
    FlashLabel = { fg = colours.light_blue, bg = colours.pink, bold = true },
  },
  highlight_undo = {
    HighlightUndo = { link = "Yank" },
    HighlightRedo = { link = "HighlightUndo" },
  },
  substitute = {
    SubstituteSubstituted = { link = "Yank" },
    SubstituteExchange = { link = "Yank" },
  },
  glance = {
    GlanceListNormal = { bg = colours.border },
    GlancePreviewNormal = { link = "GlanceListNormal" },
    GlanceListBorderBottom = { fg = colours.dark_border, bg = colours.border },
    GlanceListCursorLine = { link = "CursorLine" },
    GlancePreviewCursorLine = { link = "GlanceListCursorLine" },
    GlancePreviewBorderBottom = { link = "GlanceListBorderBottom" },
    GlanceBorderTop = { link = "GlanceListBorderBottom" },
    GlanceFoldIcon = { link = "FoldColumn" },
    GlanceWinBarTitle = { fg = colours.dark_grey, bg = colours.dark_border, bold = true },
    GlanceWinBarFilename = { link = "GlanceWinBarTitle" },
    GlanceWinBarFilepath = { fg = colours.dark_grey, bg = colours.dark_border },
  },
  -- Neogit is a bit odd that you can't reset the highlights (to NONE as in empty {}), because it just overwrites that.
  -- So for some of them they need to be set manually to the desired ones.
  neogit = {
    NeogitDiffAdd = { link = "diffAdded" },
    NeogitDiffAddCursor = { link = "NeogitDiffAdd" },
    NeogitDiffAddHighlight = { link = "NeogitDiffAdd" },

    NeogitDiffDelete = { link = "diffRemoved" },
    NeogitDiffDeleteCursor = { link = "NeogitDiffDelete" },
    NeogitDiffDeleteHighlight = { link = "NeogitDiffDelete" },

    NeogitDiffContext = { bg = colours.bg },
    NeogitDiffContextCursor = { link = "CursorLine" },
    NeogitDiffContextHighlight = { link = "NeogitDiffContext" },

    NeogitDiffHeader = { fg = colours.blue, bold = true },
    NeogitDiffHeaderHighlight = { link = "NeogitDiffHeader" },

    NeogitUntrackedfiles = { fg = colours.red, bold = true },
    NeogitUnstagedchanges = { fg = colours.orange, bold = true },
    NeogitStagedchanges = { fg = colours.green, bold = true },

    NeogitChangeAdded = { link = "DiffviewStatusAdded" },
    NeogitChangeDeleted = { link = "DiffviewStatusDeleted" },
    NeogitChangeModified = { link = "DiffviewStatusModified" },
    NeogitChangeUntracked = { link = "DiffviewStatusUntracked" },
    NeogitChangeNewFile = { link = "NeogitChangeAdded" },
    NeogitChangeRenamed = { fg = colours.blue, bold = true },

    NeogitHunkHeader = { link = "diffLine" },
    NeogitHunkHeaderCursor = { link = "NeogitHunkHeader" },
    NeogitHunkHeaderHighlight = { link = "NeogitHunkHeader" },

    NeogitHunkMergeHeader = { fg = colours.purple, bold = true },
    NeogitHunkMergeHeaderCursor = { link = "NeogitHunkMergeHeader" },
    NeogitHunkMergeHeaderHighlight = { link = "NeogitHunkMergeHeader" },

    NeogitStash = { fg = colours.blue, bold = true },
    NeogitStatusHead = { fg = colours.orange, bold = true },

    NeogitPopupActionKey = { fg = colours.cyan },
    NeogitPopupSwitchKey = { link = "NeogitPopupActionKey" },
    NeogitPopupSectionTitle = { fg = colours.orange, bold = true },
    NeogitPopupSwitchEnabled = { fg = colours.purple, bold = true },

    -- Stop setting these unwanted settings for no reason.
    NeogitCursorLine = { link = "CursorLine" },
    NeogitCursorLineNr = { link = "CursorLineNr" },

    NeogitFloatHeader = { fg = colours.blue, bold = true },
    NeogitFloatHeaderHighlight = { link = "NeogitFloatHeader" },
    NeogitCommitViewHeader = { link = "NeogitFloatHeader" },

    NeogitBranch = { fg = colours.cyan, bold = true },
    NeogitBranchHead = { link = "NeogitBranch" },
    NeogitRemote = { link = "NeogitBranch" },
    NeogitFilePath = { fg = colours.cyan },
    NeogitObjectId = { fg = colours.pink },
  },
  diffview = {
    DiffviewStatusAdded = { fg = colours.green, bold = true },
    DiffviewStatusDeleted = { fg = colours.red, bold = true },
    DiffviewStatusModified = { fg = colours.orange, bold = true },
    DiffviewStatusUntracked = { fg = colours.light_grey, bold = true },
    DiffviewFilePanelSelected = { fg = colours.pink, bold = true },

    DiffviewFilePanelFileName = { link = "Normal" },
  },
  lazy = {
    LazyButton = { bg = colours.dark_border },
    LazyH1 = { bg = colours.blue, fg = colours.light_blue, bold = true },
  },
  grugfar = {
    GrugFarResultsMatch = { link = "LspReferenceText" },
    GrugFarInputLabel = { link = "DiagnosticSignInfo" },
    GrugFarResultsHeader = { link = "SignColumn" },
    GrugFarResultsStats = { link = "GrugFarResultsHeader" },
    GrugFarResultsCmdHeader = { link = "Title" },
  },
}

local M = {
  background = "light",
  colours = colours,
  theme = theme,
}

function M.load_theme()
  reset_highlight()
  vim.opt.background = M.background
  for _, definitions in pairs(M.theme) do
    for group, colour in pairs(definitions) do
      -- Namespace = 0 to apply it globally
      vim.api.nvim_set_hl(0, group, colour)
    end
  end
end

return M
