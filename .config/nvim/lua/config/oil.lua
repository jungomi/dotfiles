local oil = require("oil")
local oil_mappings = require("mappings.oil")

local M = {}

function M.setup()
  oil.setup({
    columns = {
      "icon",
      { "size", highlight = "Comment" },
    },
    lsp_file_methods = {
      autosave_changes = "unmodified",
    },
    keymaps = {
      -- Don't overwrite my mappings
      ["<C-h>"] = false,
      ["<C-l>"] = false,
      ["<C-t>"] = false,
      ["<C-r>"] = "actions.refresh",
      -- Usual split binding for horizontal
      -- Would also like <C-v> for vertical but the problem is that I need visual block selection,
      -- so will just use the default <C-s> for that.
      ["<C-x>"] = "actions.select_split",
      ["<BS>"] = "actions.parent",
      ["gq"] = "actions.close",
    },
    float = {
      override = function(conf)
        -- Float at the bottom
        local height = math.ceil(conf.height * 0.45)
        local width = math.ceil(conf.width * 0.95)
        local col = conf.col + (conf.width - width) / 2
        local row = conf.row + conf.height - height + 1
        local opts = { height = height, width = width, col = col, row = row }
        return vim.tbl_extend("force", conf, opts)
      end,
    },
  })
  oil_mappings.enable_mappings()
end

return M
