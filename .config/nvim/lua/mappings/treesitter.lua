local ts_move = require("nvim-treesitter-textobjects.move")
local ts_select = require("nvim-treesitter-textobjects.select")
local ts_swap = require("nvim-treesitter-textobjects.swap")
local ts_utils = require("utils.treesitter")
local map_utils = require("utils.map")
local map = map_utils.map
local nmap = map_utils.nmap
local imap = map_utils.imap

local M = {}

function M.enable_mappings()
  -- Jump to class
  map({ "n", "x", "o" }, "]c", function()
    ts_move.goto_next_start("@class.outer", "textobjects")
  end, { desc = "Treesitter » Jump next start of Class" })
  map({ "n", "x", "o" }, "]C", function()
    ts_move.goto_next_end("@class.outer", "textobjects")
  end, { desc = "Treesitter » Jump next end of Class" })
  map({ "n", "x", "o" }, "[c", function()
    ts_move.goto_previous_start("@class.outer", "textobjects")
  end, { desc = "Treesitter » Jump previous start of Class" })
  map({ "n", "x", "o" }, "[C", function()
    ts_move.goto_previous_end("@class.outer", "textobjects")
  end, { desc = "Treesitter » Jump previous end of Function" })
  -- Jump to function
  map({ "n", "x", "o" }, "]f", function()
    ts_move.goto_next_start("@function.outer", "textobjects")
  end, { desc = "Treesitter » Jump next start of Function" })
  map({ "n", "x", "o" }, "]F", function()
    ts_move.goto_next_end("@function.outer", "textobjects")
  end, { desc = "Treesitter » Jump next end of Class" })
  map({ "n", "x", "o" }, "[f", function()
    ts_move.goto_previous_start("@function.outer", "textobjects")
  end, { desc = "Treesitter » Jump previous start of Function" })
  map({ "n", "x", "o" }, "[F", function()
    ts_move.goto_previous_end("@function.outer", "textobjects")
  end, { desc = "Treesitter » Jump previous end of Function" })
  -- Swap parameters
  nmap("]a", function()
    ts_swap.swap_next("@parameter.inner")
  end, { desc = "Treesitter » Swap Next" })
  nmap("[a", function()
    ts_swap.swap_previous("@parameter.inner")
  end, { desc = "Treesitter » Swap Previous" })
  -- Select class
  map({ "x", "o" }, "ic", function()
    ts_select.select_textobject("@class.inner", "textobjects")
  end, { desc = "Treesitter » Select inside of Class" })
  map({ "x", "o" }, "ac", function()
    ts_select.select_textobject("@class.outer", "textobjects")
  end, { desc = "Treesitter » Select around Class" })
  -- Select function
  map({ "x", "o" }, "if", function()
    ts_select.select_textobject("@function.inner", "textobjects")
  end, { desc = "Treesitter » Select inside of Function" })
  map({ "x", "o" }, "af", function()
    ts_select.select_textobject("@function.outer", "textobjects")
  end, { desc = "Treesitter » Select around Function" })

  -- Generate DocString of the object under the cursor
  nmap("<leader>sd", "<Cmd>Neogen<CR>", { desc = "Treesitter » Generate DocString" })
  imap("<C-a>", ts_utils.jump_start_of_node, { desc = "Treesitter » Jump to start of Node" })
  imap("<C-e>", ts_utils.jump_end_of_node, { desc = "Treesitter » Jump to end of Node" })
end

return M
