local M = {}

-- Filter the diagnostics per line to show the highest priority.
-- By default, the LSP just displays the last diagnostic, without
-- instead of showing the one with the highest priority.
function M.filter_diagnostics_per_line_by_severity(diagnostics)
  local line_diagnostics = {}
  for _, diag in pairs(diagnostics) do
    local line_nr = diag.range.start.line
    local line_diag = line_diagnostics[line_nr]
    -- Only keep the diagnostic if there is no higher priority one.
    -- The lower the severity the higher its priority (1 = error, 2 = warning, etc.)
    -- In case of having the same severity, the last one is displayed (kind of like original behaviour).
    if not line_diag or diag.severity <= line_diag.severity then
      line_diagnostics[line_nr] = diag
    end
  end

  -- Convert back to a list
  local filtered_diagnostics = {}
  for _, diag in pairs(line_diagnostics) do
    table.insert(filtered_diagnostics, diag)
  end

  return filtered_diagnostics
end

return M
