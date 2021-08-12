local M = {}

-- Filter the diagnostics per line to show the highest priority.
-- By default, the LSP just displays the last diagnostic, without
-- instead of showing the one with the highest priority.
function M.filter_diagnostics_per_line_by_severity(diagnostics, last_only)
  local line_diagnostics = {}
  for _, diag in pairs(diagnostics) do
    local line_nr = diag.range.start.line
    local line_diag = line_diagnostics[line_nr]
    -- Only keep the diagnostic if there is no higher priority one.
    -- The lower the severity the higher its priority (1 = error, 2 = warning, etc.)
    if not line_diag or diag.severity < line_diag.severity then
      line_diagnostics[line_nr] = { severity = diag.severity, diagnostics = { diag } }
    elseif diag.severity == line_diag.severity then
      -- In case of having the same severity all of them are kept unless last_only=true
      if last_only then
        line_diagnostics[line_nr].diagnostics = { diag }
      else
        table.insert(line_diagnostics[line_nr].diagnostics, diag)
      end
    end
  end

  -- Convert back to a list
  local filtered_diagnostics = {}
  for _, diag in pairs(line_diagnostics) do
    for _, d in pairs(diag.diagnostics) do
      table.insert(filtered_diagnostics, d)
    end
  end

  return filtered_diagnostics
end

return M
