local borders = {
  empty = { " ", " ", " ", " ", " ", " ", " ", " " },

  -- For hover popups (LSP)
  -- Just the top bar.
  hover = { "―", "―", "―", " ", " ", " ", " ", " " },
}

borders.default = borders.empty
borders.hidden = "none"

return borders
