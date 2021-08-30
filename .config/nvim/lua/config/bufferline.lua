local buffer_line = require("bufferline")
local buffer_line_mappings = require("mappings.bufferline")
local colours = require("theme").colours

local M = {}

local diagnostic_kinds = {
  error = {
    icon = "",
    highlight = {
      selected = "ES",
      visible = "EV",
      hidden = "EH",
    },
  },
  warning = {
    icon = "",
    highlight = {
      selected = "WS",
      visible = "WV",
      hidden = "WH",
    },
  },
  info = {
    icon = "",
    highlight = {
      selected = "IS",
      visible = "IV",
      hidden = "IH",
    },
  },
  hint = {
    icon = "",
    highlight = {
      selected = "HS",
      visible = "HV",
      hidden = "HH",
    },
  },
  other = {
    icon = "",
    highlight = {
      selected = "HS",
      visible = "HV",
      hidden = "HH",
    },
  },
}

-- Default styles of the three types of buffers to override unwanted styles
local hidden = { guifg = colours.grey, guibg = colours.dark_border }
local visible = { guifg = colours.grey, guibg = colours.cursor_line }
local selected = { guifg = colours.fg, guibg = colours.bg, gui = "bold" }

local function diagnostics_indicator(count, level, diagnostics_dict, context)
  local parts = {}
  for kind, diag in pairs(diagnostic_kinds) do
    local diag_count = diagnostics_dict[kind]
    if diag_count then
      local highlight = diag.highlight.hidden
      if context.buffer:current() then
        highlight = diag.highlight.selected
      elseif context.buffer:visible() then
        highlight = diag.highlight.visible
      end
      -- The spaces are manually inserted because of the highlighting
      -- otherwise the first space does not have the correct background colour.
      table.insert(parts, string.format("%%#%s# %s %d", highlight, diag.icon, diag_count))
    end
  end
  return table.concat(parts)
end

function M.setup()
  buffer_line.setup({
    options = {
      numbers = function(opts)
        return string.format("%s.", opts.id)
      end,
      diagnostics = "nvim_lsp",
      show_buffer_icons = true,
      modified_icon = "",
      -- Don't need the  as I'm not using the mouse anyway
      show_close_icon = false,
      show_buffer_close_icons = false,
      -- Tab numbers at the right end
      show_tab_indicators = true,
      diagnostics_indicator = diagnostics_indicator,
      indicator_icon = "▍",
      separator_style = { "", "" },
    },
    highlights = {
      fill = { guibg = colours.dark_border },
      tab_selected = { guifg = colours.blue, guibg = colours.border, gui = "bold" },
      buffer_selected = selected,
      buffer_visible = visible,
      background = hidden,
      -- These are all italic by default, also don't want the colour
      diagnostic_selected = selected,
      error_selected = selected,
      warning_selected = selected,
      info_selected = selected,
      diagnostic_visible = visible,
      error_visible = visible,
      warning_visible = visible,
      info_visible = visible,
      diagnostic = hidden,
      error = hidden,
      warning = hidden,
      info = hidden,
      duplicate = { guifg = colours.grey, guibg = colours.dark_border, gui = "italic" },
      duplicate_visible = { guifg = colours.grey, guibg = colours.cursor_line, gui = "italic" },
      duplicate_selected = { guifg = colours.grey, guibg = colours.bg, gui = "italic" },
      modified = hidden,
      modified_visible = visible,
      modified_selected = selected,
      pick = { guifg = colours.red, guibg = colours.dark_border },
      pick_visible = { guifg = colours.red, guibg = colours.cursor_line },
      pick_selected = { guifg = colours.red, guibg = colours.bg },
    },
  })
  buffer_line_mappings.enable_mappings()
end

return M
