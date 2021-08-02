local highlight = require("utils.highlight").highlight
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

  dark_border = "#cac4b5",

  statusline = {
    text = "#bbc2cf",
    active = "#242b37",
    inactive = "#485364",
  },
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
    CursorLineNr = { bg = colours.border, fg = colours.fg, style = "bold" },
    SignColumn = { bg = colours.border, fg = colours.grey },
    FoldColumn = { bg = colours.border, fg = colours.grey },
    Folded = { bg = colours.border },
    qfLineNr = { fg = colours.purple, style = "italic" },

    TabLine = { bg = colours.border, fg = colours.grey },
    TabLineFill = { bg = colours.border, fg = colours.grey },
    TabLineSel = { bg = colours.purple, fg = colours.grey },

    StatusLine = { bg = colours.statusline.active, fg = colours.statusline.text, style = "bold" },
    StatusLineNC = { bg = colours.statusline.inactive, fg = colours.statusline.text },

    PMenu = { bg = colours.cursor_line },
    PMenuSel = { bg = colours.yellow },
    PMenuSbar = { bg = colours.cursor_line },
    PMenuThumb = { bg = colours.grey },

    ErrorMsg = { fg = colours.red, style = "bold" },
    ModeMsg = { fg = colours.green, style = "bold" },
    MoreMsg = { fg = colours.blue, style = "bold" },
    WarningMsg = { fg = colours.orange, style = "bold" },
    Question = { fg = colours.blue, style = "bold" },
    Title = { fg = colours.blue, style = "bold" },
    Directory = { fg = colours.blue, style = "bold" },
    healthSuccess = "ModeMsg",

    MatchParen = { bg = colours.grey, fg = colours.bg },

    SpellBad = { style = "undercurl" },
    SpellCap = { style = "undercurl" },
    SpellLocal = { style = "undercurl" },
    SpellRare = { style = "undercurl" },
  },
  syntax = {
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
    Underlined = { style = "underline" },
  },
  treesitter = {
    -- Only groups that are not linked to the desired default, rest (mostly TSxxx -> xxx) is skipped
    -- e.g. TSBoolean -> Boolean (skipped)
    TSConstBuiltin = "Constant",
    TSConstMacro = "Macro",
    TSConstructor = "Function",
    TSError = "Error",
    TSField = { fg = colours.fg },
    TSFuncBuiltin = "Function",
    TSInclude = { fg = colours.purple },
    TSKeywordOperator = { fg = colours.purple },
    TSNamespace = { fg = colours.red },
    TSNote = { fg = colours.cyan, style = "bold" },
    TSParameter = { fg = colours.cyan },
    TSProperty = { fg = colours.cyan },
    TSSymbol = { fg = colours.cyan },
    TSVariable = { fg = colours.fg },
    TSTag = { fg = colours.purple },
  },
  lsp = {
    -- Defaults (mostly for fallbacks)
    LspDiagnosticsDefaultError = { fg = colours.red },
    LspDiagnosticsDefaultWarning = { fg = colours.orange },
    LspDiagnosticsDefaultInformation = { fg = colours.blue },
    LspDiagnosticsDefaultHint = { fg = colours.cyan },

    -- Signs
    LspDiagnosticsSignError = { fg = colours.red, bg = colours.border },
    LspDiagnosticsSignWarning = { fg = colours.orange, bg = colours.border },
    LspDiagnosticsSignInformation = { fg = colours.blue, bg = colours.border },
    LspDiagnosticsSignHint = { fg = colours.cyan, bg = colours.border },

    -- Virtual text
    LspDiagnosticsVirtualTextError = { fg = colours.red, style = "italic" },
    LspDiagnosticsVirtualTextWarning = { fg = colours.orange, style = "italic" },
    LspDiagnosticsVirtualTextInformation = { fg = colours.blue, style = "italic" },
    LspDiagnosticsVirtualTextHint = { fg = colours.cyan, style = "italic" },

    -- Floating window text
    LspDiagnosticsFloatingError = { fg = colours.red },
    LspDiagnosticsFloatingWarning = { fg = colours.orange },
    LspDiagnosticsFloatingInformation = { fg = colours.blue },
    LspDiagnosticsFloatingHint = { fg = colours.cyan },

    -- Underline the corresponding text
    LspDiagnosticsUnderlineError = { style = "undercurl", special = colours.red },
    LspDiagnosticsUnderlineWarning = { style = "undercurl", special = colours.orange },
    LspDiagnosticsUnderlineInformation = { style = "undercurl", special = colours.blue },
    LspDiagnosticsUnderlineHint = { style = "undercurl", special = colours.cyan },

    -- Highlighting of References
    LspReferenceText = { bg = colours.cursor_line },
    LspReferenceRead = { bg = colours.cursor_line },
    LspReferenceWrite = { bg = colours.cursor_line },

    -- Trouble
    TroubleIndent = { fg = colours.grey },
    TroubleCount = { fg = colours.grey, style = "italic" },
    TroubleFoldIcon = { fg = colours.grey },
    TroubleLocation = { fg = colours.purple, style = "italic" },
    TroubleSignError = { fg = colours.red },
    TroubleSignWarning = { fg = colours.orange },
    TroubleSignInformation = { fg = colours.blue },
    TroubleSignHint = { fg = colours.cyan },

    -- Saga
    -- So many unnecessary border/line highlight groups
    LspSagaAutoPreview = "FloatBorder",
    LspSagaAutoPreviewBorder = "FloatBorder",
    LspSagaCodeActionBorder = "FloatBorder",
    LspSagaDefPreviewBorder = "FloatBorder",
    LspSagaDiagnosticBorder = "FloatBorder",
    LspSagaHoverBorder = "FloatBorder",
    LspSagaLspFinderBorder = "FloatBorder",
    LspSagaSignatureHelpBorder = "FloatBorder",
    LspSagaRenameBorder = "FloatBorder",
    LspSagaRenamePromptPrefix = { fg = colours.grey },
    LspSagaCodeActionTruncateLine = "FloatBorder",
    LspSagaDiagnosticTruncateLine = "FloatBorder",
    LspSagaDocTruncateLine = "FloatBorder",
    LspSagaShTruncateLine = "FloatBorder",
    LspSagaLightBulb = { fg = colours.light_orange },
    LspSagaLightBulbSign = { fg = colours.light_orange, bg = colours.border },
    LspSagaFinderSelection = { bg = colours.cursor_line },
    LspSagaCodeActionTitle = { fg = colours.grey, style = "bold" },
    LspSagaDiagnosticHeader = { fg = colours.grey, style = "bold" },
    LspSagaCodeActionContent = { fg = colours.grey },
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
    DiffText = { fg = colours.blue, bg = colours.light_blue, style = "bold" },

    -- Colours in git commit messages
    gitcommitSummary = { fg = colours.green },
    gitcommitOverflow = { fg = colours.red },
    gitcommitHeader = { fg = colours.blue },
    -- Staged files
    gitcommitSelectedFile = { fg = colours.green },
    gitcommitSelectedType = { fg = colours.green, style = "bold" },
    -- Unstaged files
    gitcommitDiscardedFile = { fg = colours.orange },
    gitcommitDiscardedType = { fg = colours.orange, style = "bold" },
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

    fugitiveHash = { fg = colours.red },
    fugitiveHeading = "Title",
    fugitiveSymbolicRef = "Special",
    fugitiveStagedHeading = { fg = colours.green, style = "bold" },
    fugitiveStagedModifier = { fg = colours.green },
    fugitiveUnstagedHeading = { fg = colours.orange, style = "bold" },
    fugitiveUnstagedModifier = { fg = colours.orange },
    fugitiveUntrackedHeading = { fg = colours.red, style = "bold" },
    fugitiveUntrackedModifier = { fg = colours.red },
  },
  dap = {
    DapUIBreakpointsPath = "Directory",
    DapUIBreakpointsInfo = { fg = colours.cyan },
    DapUIBreakpointsCurrentLine = { fg = colours.fg, style = "bold" },
    DapUIFloatBorder = "FloatBorder",
    DapUIFrameName = { fg = colours.purple },
    DapUIDecoration = { fg = colours.cyan },
    DapUILineNumber = { fg = colours.grey },
    DapUIScope = "Title",
    DapUISource = "Directory",
    DapUIStoppedThread = { fg = colours.red, style = "bold" },
    DapUIThread = { fg = colours.cyan, style = "bold" },
    DapUIType = "Type",
    DapUIVariable = { fg = colours.purple },
    DapUIWatchesEmpty = { fg = colours.grey },
    DapUIWatchesError = { fg = colours.red },
    DapUIWatchesValue = { fg = colours.cyan },

    NvimDapVirtualText = { fg = colours.grey, style = "italic" },

    -- Custom statusline for dap-ui (not part of the plugin)
    DapUIStatusline = { fg = colours.grey, bg = colours.bg, gui = "bold" },
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
      highlight(group, colour)
    end
  end
end

return M
