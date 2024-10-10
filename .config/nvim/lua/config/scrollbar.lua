local scrollview = require("scrollview")
local scrollview_gitsigns = require("scrollview.contrib.gitsigns")
local scrollbar_mappings = require("mappings.scrollbar")
local icons = require("icons")

local M = {}

function M.setup()
  scrollview.setup({
    current_only = true,
    winblend = 0,
    signs_on_startup = { "cursor", "diagnostics", "search" },
    -- Most symbols have a Thin Space (U+2009) in order to keep the icons smaller.
    diagnostics_error_symbol = icons.pad_right(icons.diagnostic.Error, 1, icons.thin_space),
    diagnostics_warn_symbol = icons.pad_right(icons.diagnostic.Warn, 1, icons.thin_space),
    diagnostics_info_symbol = icons.pad_right(icons.diagnostic.Info, 1, icons.thin_space),
    diagnostics_hint_symbol = icons.pad_right(icons.diagnostic.Hint, 1, icons.thin_space),
    cursor_priority = 0,
    cursor_symbol = icons.pad_right(icons.triangle.small, 1, icons.thin_space),
    search_symbol = icons.right_bar,
    spell_symbol = icons.pad_right(icons.lsp_kind.Text, 1),
  })

  scrollview_gitsigns.setup({
    add_symbol = icons.right_bar,
    change_symbol = icons.right_bar,
    delete_symbol = icons.right_bar,
  })

  scrollbar_mappings.enable_mappings()
end

return M
