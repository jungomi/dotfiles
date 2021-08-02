local M = {}

-- Highlight a group configured by a table or link it if a string is given.
-- If an option is left it it is set to NONE (transparent) not left unchanged.
function M.highlight(group, colour)
  if type(colour) == "table" then
    vim.cmd(
      string.format(
        "highlight %s guifg=%s guibg=%s gui=%s guisp=%s",
        group,
        colour.fg or "NONE",
        colour.bg or "NONE",
        colour.style or "NONE",
        colour.special or "NONE"
      )
    )
  else
    vim.cmd(string.format("highlight link %s %s", group, colour))
  end
end

-- Reset all highlighting
function M.reset_highlight()
  vim.cmd("highlight clear")
  if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
  end
end

return M
