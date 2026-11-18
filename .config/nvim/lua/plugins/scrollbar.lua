local icons = require("icons")
local nmap = require("utils.map").nmap

local M = {
  -- Scrollbar
  "dstein64/nvim-scrollview",
}

function M.config()
  require("scrollview").setup({
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

  require("scrollview.contrib.gitsigns").setup({
    add_symbol = icons.right_bar,
    change_symbol = icons.right_bar,
    delete_symbol = icons.right_bar,
  })
end

function M.keys()
  -- Navigation to signs
  nmap("]v", "<Cmd>ScrollViewNext<CR>", { desc = "Scrollbar » Jump to next sign" })
  nmap("[v", "<Cmd>ScrollViewPrev<CR>", { desc = "Scrollbar » Jump to previous sign" })
  nmap("[V", "<Cmd>ScrollViewFirst<CR>", { desc = "Scrollbar » Jump to first sign" })
  nmap("]V", "<Cmd>ScrollViewLast<CR>", { desc = "Scrollbar » Jump to last sign" })
  nmap("<leader>sv", "<Cmd>ScrollViewToggle spell<CR>", { desc = "Scrollbar » Toggle Spell Signs" })
end

return M
