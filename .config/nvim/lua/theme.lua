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
  dark_border = "#cac4b5",
}

local theme = {
  base = {
    Normal = { fg = colours.fg },
    NormalFloat = { bg = colours.bg },
    FloatBorder = { bg = colours.bg, fg = colours.grey },
    VertSplit = { fg = colours.orange },

    Cursor = { bg = colours.fg, fg = colours.bg },
    CursorLine = { bg = colours.cursor_line },
    CursorColumn = { bg = colours.cursor_line },
    ColorColumn = { bg = colours.light_grey },
    Visual = { bg = colours.yellow },
    VisualNOS = { bg = colours.light_orange },
    Search = { bg = colours.yellow },
    IncSearch = { bg = colours.orange, fg = colours.fg },
    Yank = { bg = colours.light_orange },

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
  },
  lsp = {
    -- Defaults (mostly for fallbacks)
    DiagnosticError = { fg = colours.red },
    DiagnosticWarn = { fg = colours.orange },
    DiagnosticInfo = { fg = colours.blue },
    DiagnosticHint = { fg = colours.cyan },

    -- Signs
    DiagnosticSignError = { fg = colours.red, bg = colours.border },
    DiagnosticSignWarn = { fg = colours.orange, bg = colours.border },
    DiagnosticSignInfo = { fg = colours.blue, bg = colours.border },
    DiagnosticSignHint = { fg = colours.cyan, bg = colours.border },

    -- Virtual text
    DiagnosticVirtualTextError = { fg = colours.red, italic = true },
    DiagnosticVirtualTextWarn = { fg = colours.orange, italic = true },
    DiagnosticVirtualTextInfo = { fg = colours.blue, italic = true },
    DiagnosticVirtualTextHint = { fg = colours.cyan, italic = true },

    -- Floating window text
    DiagnosticFloatingError = { fg = colours.red },
    DiagnosticFloatingWarn = { fg = colours.orange },
    DiagnosticFloatingInfo = { fg = colours.blue },
    DiagnosticFloatingHint = { fg = colours.cyan },

    -- Underline the corresponding text
    DiagnosticUnderlineError = { undercurl = true, special = colours.red },
    DiagnosticUnderlineWarn = { undercurl = true, special = colours.orange },
    DiagnosticUnderlineInfo = { undercurl = true, special = colours.blue },
    DiagnosticUnderlineHint = { undercurl = true, special = colours.cyan },

    -- Highlighting of References
    LspReferenceText = { bg = colours.cursor_line },
    LspReferenceRead = { bg = colours.cursor_line },
    LspReferenceWrite = { bg = colours.cursor_line },

    -- Signature popup
    LspSignatureActiveParameter = { link = "Search" },

    -- Trouble
    TroubleIndent = { fg = colours.grey },
    TroubleCount = { fg = colours.grey, italic = true },
    TroubleFoldIcon = { fg = colours.grey },
    TroubleLocation = { fg = colours.purple, italic = true },
    TroubleSignError = { fg = colours.red },
    TroubleSignWarning = { fg = colours.orange },
    TroubleSignInformation = { fg = colours.blue },
    TroubleSignHint = { fg = colours.cyan },

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
    DiffDelete = { fg = colours.red, bg = colours.light_red },
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

    GitSignsAdd = { fg = colours.green, bg = colours.border },
    GitSignsChange = { fg = colours.blue, bg = colours.border },
    GitSignsDelete = { fg = colours.red, bg = colours.border },
    -- Inline word diffs
    GitSignsAddInline = { link = "DiffAdd" },
    GitSignsChangeInline = { link = "DiffText" },
    GitSignsDeleteInline = { link = "DiffDelete" },

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

    NoiceCmdlinePopupBorder = { link = "NoiceCmdlineIcon" },
    NoiceCmdlinePopupBorderSearch = { link = "NoiceCmdlineIconSearch" },
    NoiceConfirmBorder = { link = "NoiceCmdlinePopupBorder" },

    NoiceMini = { fg = colours.grey, bg = colours.cursor_line },
    NoiceFormatProgressDone = { fg = colours.grey, bg = colours.dark_border, bold = true },
    NoiceFormatProgressTodo = { fg = colours.dark_border, bold = true },
    NoiceLspProgressTitle = { fg = colours.grey },
    NoiceLspProgressSpinner = { fg = colours.grey, bold = true },
  },
  -- Floating Winbar showing buffer name at the top right of the window
  incline = {
    InclineNormal = { fg = colours.grey, bg = colours.cursor_line, bold = true },
    InclineNormalNC = { fg = colours.grey, bg = colours.border },
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
