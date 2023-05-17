local buffer_line = require("bufferline")
local buffer_line_mappings = require("mappings.bufferline")
local scope = require("scope")
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
    icon = "󰌵",
    highlight = {
      selected = "HS",
      visible = "HV",
      hidden = "HH",
    },
  },
  other = {
    icon = "󰌵",
    highlight = {
      selected = "HS",
      visible = "HV",
      hidden = "HH",
    },
  },
}

-- Default styles of the three types of buffers to override unwanted styles
local hidden = { fg = colours.grey, bg = colours.dark_border }
local visible = { fg = colours.grey, bg = colours.cursor_line }
local selected = { fg = colours.fg, bg = colours.bg, bold = true, italic = false }

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
        return string.format("%s.", opts.ordinal)
      end,
      diagnostics = "nvim_lsp",
      show_buffer_icons = true,
      modified_icon = "󰃉",
      -- Don't need the 󰅖 as I'm not using the mouse anyway
      show_close_icon = false,
      show_buffer_close_icons = false,
      -- Tab numbers at the right end
      show_tab_indicators = true,
      diagnostics_indicator = diagnostics_indicator,
      indicator = {
        icon = "▍",
        style = "icon",
      },
      separator_style = { "", "" },
    },
    highlights = {
      fill = { bg = colours.dark_border },
      tab = { fg = colours.grey, bg = colours.bg },
      tab_selected = { fg = colours.blue, bg = colours.bg, bold = true, italic = false },
      buffer_selected = selected,
      buffer_visible = visible,
      background = hidden,
      -- These are all italic by default, also don't want the colour
      diagnostic_selected = selected,
      error_selected = selected,
      warning_selected = selected,
      hint_selected = selected,
      info_selected = selected,
      diagnostic_visible = visible,
      error_visible = visible,
      warning_visible = visible,
      hint_visible = visible,
      info_visible = visible,
      diagnostic = hidden,
      error = hidden,
      warning = hidden,
      hint = hidden,
      info = hidden,
      duplicate = { fg = colours.grey, bg = colours.dark_border, italic = true },
      duplicate_visible = { fg = colours.grey, bg = colours.cursor_line, italic = true },
      duplicate_selected = { fg = colours.grey, bg = colours.bg, italic = true },
      modified = hidden,
      modified_visible = visible,
      modified_selected = selected,
      pick = { fg = colours.red, bg = colours.dark_border },
      pick_visible = { fg = colours.red, bg = colours.cursor_line },
      pick_selected = { fg = colours.red, bg = colours.bg },
      separator = hidden,
      separator_selected = selected,
      separator_visible = visible,
      numbers = hidden,
      numbers_selected = selected,
      numbers_visible = visible,
      indicator_visible = visible,
    },
  })

  -- This kind of replaces :b <id>, as that is much more frequently used than the full :buffer
  -- as the buffer number is no longer shown, this uses the id shown in the buffer line.
  vim.api.nvim_create_user_command("B", function(opts)
    -- The second argument is aboslute=true, otherwise the selection counts only the visible buffers, which
    -- does not correspond to the ordinal number if some of the first ones are scrolled off.
    buffer_line.go_to_buffer(opts.args, true)
  end, { nargs = 1, desc = "Buffer » Switch to id" })

  scope.setup()

  buffer_line_mappings.enable_mappings()
end

return M
