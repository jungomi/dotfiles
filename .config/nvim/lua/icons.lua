local icons = {
  -- This is a Thin Space (U+2009) which can be used to keep some icons smaller
  -- that use 2 code points to display fully. A Thin Space right afterwards prevents that.
  thin_space = " ",

  fold = {
    expanded = "",
    collapsed = "",
  },
  diagnostic = {
    -- These are intentionally uppercase so they can be used to map to the names directly.
    Error = "",
    Warn = "",
    Info = "",
    Hint = "󰌵",
  },
  bufferline = {
    separator = "▍",
  },

  modified = "󰃉",
  readonly = "",
  tab = "󰌒",
  question = "",
  dot = "",
  lightning = "",
  mic = "",
  right_bar = "🮇",
  terminal = " ",
  bulb = "💡",
  magnify = "🔍",
  window = "",
  hash = "",
  location = "",
  copyright = "",

  arrow = {
    thick = "󰁕",
    hook = "↪",

    incoming = "",
    outgoing = "",
  },
  triangle = {
    normal = "",
    small = "",
    tiny = "‣",
  },
  double_angle = {
    left = "«",
    right = "»",
    up = "",
    down = "",
  },
  git = {
    branch = "",
  },

  mason = {
    server_installed = "✓",
    server_pending = "⟳",
    server_uninstalled = "",
  },

  lsp_kind = {
    Class = "⚛",
    Color = "",
    Constant = "",
    Constructor = "",
    Enum = "",
    EnumMember = "",
    Event = "",
    Field = "󰄶",
    File = "",
    Folder = "",
    Function = "⨍",
    Interface = "↯",
    Keyword = "󰌆",
    Method = "⨍",
    Module = "󰏗",
    Operator = "󰆕",
    Property = "",
    Reference = "󰈇",
    Snippet = "✐",
    Struct = "",
    Text = "",
    TypeParameter = "",
    Unit = "",
    Value = "󰎠",
    Variable = "≝",
  },
}

function icons.pad(str, left, right, char)
  char = char or " "
  if left and left > 0 then
    str = string.rep(char, left) .. str
  end
  if right and right > 0 then
    str = str .. string.rep(char, right)
  end
  return str
end
function icons.pad_left(str, num, char)
  return icons.pad(str, num, nil, char)
end
function icons.pad_right(str, num, char)
  return icons.pad(str, nil, num, char)
end

return icons
