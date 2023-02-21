local telescope = require("telescope")
local actions = require("telescope.actions")
local fuzzy_mappings = require("mappings.fuzzy")

local M = {}

function M.get_find_command()
  if vim.fn.executable("fd") == 1 then
    return { "fd", "--type", "f", "--hidden", "--follow", "--exclude", ".git" }
  elseif vim.fn.executable("rg") == 1 then
    return { "rg", "--files", "--hidden", "--smart-case", "--glob", "!.git" }
  end
end

function M.setup()
  telescope.setup({
    extensions = {
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = "smart_case",
      },
    },
    defaults = {
      selection_caret = " ",
      multi_icon = "",
      mappings = {
        i = {
          ["<esc>"] = actions.close,
          ["<C-u>"] = false,
          -- That looks the wrong way around, but because I use the flipped version (bottom up) it works as expected.
          ["<C-k>"] = actions.move_selection_previous,
          ["<C-j>"] = actions.move_selection_next,
          -- Scroll preview
          ["<C-f>"] = actions.preview_scrolling_down,
          ["<C-b>"] = actions.preview_scrolling_up,
          -- Flip the multi selection
          ["<Tab>"] = actions.toggle_selection + actions.move_selection_better,
          ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_worse,
          -- Select and deselect all
          ["<M-a>"] = actions.select_all,
          ["<M-d>"] = actions.drop_all,
        },
      },
    },
    pickers = {
      find_files = {
        find_command = M.get_find_command(),
      },
    },
  })
  telescope.load_extension("fzf")

  fuzzy_mappings.enable_mappings()
end

return M
