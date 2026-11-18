local autocmd_utils = require("utils.autocmd")
local map_utils = require("utils.map")
local map = map_utils.map
local nmap = map_utils.nmap
local imap = map_utils.imap

local treesitter_spec = {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  config = function()
    local treesitter = require("nvim-treesitter")

    -- TreeSitter highlighting isn't great for these,
    -- use regular syntax highlighting instead.
    -- Markdown is disabled because it has some terrible conceals (e.g. the code fences),
    -- which interferes with markview.
    local disable_highlight = { "rust", "gitcommit", "markdown" }
    -- Latex indent from treesitter is terrible, it never indents a scope, so everything is flat.
    local disable_indent = { "latex" }

    -- A simple wrapper to create the autocmd based on the language.
    -- Since the same treesitter language is used for multiple filetypes, it is not as simple as checking
    -- if the filetype is in the disabled highlight/indent. Instead, the language defined in treesitter
    -- are used and based on that it is programmatically enaled/disabled.
    -- This just creates { highlight = true, indent = true } as a closure if they should be enabled.
    local function create_autocmd_callback(lang)
      local opts = {
        highlight = not vim.tbl_contains(disable_highlight, lang),
        indent = not vim.tbl_contains(disable_indent, lang),
      }
      return function(ev)
        if opts.highlight then
          vim.treesitter.start(ev.buf)
        end
        if opts.indent then
          -- Enable indentation through tree-sitter. It caused a lot of issues the first time I tried,
          -- but that has been many years now, and it seems to be fine. And even fixes weird
          -- indentation in Python.
          vim.api.nvim_set_option_value(
            "indentexpr",
            [[v:lua.require("nvim-treesitter").indentexpr()]],
            { buf = ev.buf }
          )
        end
      end
    end

    -- Enable autocmds for all installed languages and each of their associated filetypes.
    -- For example, the latex treesitter parser is used for tex and latex.
    -- To avoid any runtime checks on the autocmds, there is one autocmd per filetype.
    -- It might seem a little overkill, since that results in a lot of autocmds, but it still seems
    -- like a cleaner solution.
    local function enable_autocmds()
      local installed_languages = treesitter.get_installed()
      local autocmds = vim
        .iter(installed_languages)
        :map(function(lang)
          local filetypes = vim.treesitter.language.get_filetypes(lang)
          return vim
            .iter(filetypes)
            :map(function(ft)
              return {
                event = "FileType",
                pattern = ft,
                callback = create_autocmd_callback(lang),
                desc = string.format("Treesitter enable highlight and indentation for %s (lang=%s)", ft, lang),
              }
            end)
            :totable()
        end)
        :flatten(1)
        :totable()
      autocmd_utils.create_augroups({
        config_treesitter = autocmds,
      })
    end

    vim.schedule(function()
      treesitter.install("all"):wait()
      -- Need to enable autocmds for the newly installed languages.
      enable_autocmds()
    end)

    enable_autocmds()
  end,
  keys = function()
    local ts_move = require("nvim-treesitter-textobjects.move")
    local ts_select = require("nvim-treesitter-textobjects.select")
    local ts_swap = require("nvim-treesitter-textobjects.swap")
    local ts_utils = require("utils.treesitter")

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
  end,
}

return {
  treesitter_spec,
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    opts = {
      select = {
        -- Automatically jump to the next textobject if not already on it.
        lookahead = true,
      },
    },
  },
  -- Setting correct comments for nested languages
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    opts = {
      -- Don't do it all the time, only when using the commenting plugin
      enable_autocmd = false,
    },
  },
  -- Generate DocStrings
  {
    "danymat/neogen",
    opts = {
      -- Don't go into insert mode after creating the docs
      input_after_comment = false,
    },
  },
  {
    -- Automatically convert regular quotes to interpolated versions (including f-strings for Python)
    "axelvc/template-string.nvim",
    opts = {
      -- Convert to regular quotes when there is no interpolation
      remove_template_string = true,
      restore_quotes = {
        -- Use double quotes for regular quotes
        normal = [["]],
      },
    },
  },
}
