local packer_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if vim.fn.empty(vim.fn.glob(packer_path)) > 0 then
  vim.fn.system({ "git", "clone", "https://github.com/wbthomason/packer.nvim", packer_path })
  vim.cmd([[packadd packer.nvim]])
end

local packer = require("packer")
packer.startup(function(use)
  -- Packer as a plugin to automatically update
  use("wbthomason/packer.nvim")

  -- :: Appearance
  -- Status line
  use({
    "hoob3rt/lualine.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = [[require("config.statusline").setup()]],
  })
  -- Buffer/Tabs
  use({
    "akinsho/nvim-bufferline.lua",
    requires = "kyazdani42/nvim-web-devicons",
    config = [[require("config.bufferline").setup()]],
  })
  -- Highlight colour definitions (e.g. Blue, #555d60)
  use({ "norcalli/nvim-colorizer.lua", config = [[require("colorizer").setup()]] })
  -- Improved UI for vim.ui.select and vim.ui.input (e.g. floating window for LSP rename)
  use({ "stevearc/dressing.nvim", config = [[require("dressing").setup({ input = { insert_only = false } })]] })

  -- :: TreeSitter
  use("nvim-treesitter/playground")
  use("JoosepAlviste/nvim-ts-context-commentstring")
  -- Spellcheck based on TreeSitter nodes (e.g. comment only)
  use("lewis6991/spellsitter.nvim")
  -- Generate DocStrings
  use("danymat/neogen")
  use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate", config = [[require("config.treesitter").setup()]] })

  -- :: Git
  use({ "lewis6991/gitsigns.nvim", requires = "nvim-lua/plenary.nvim", config = [[require("config.git").setup()]] })

  -- :: Language Server (LSP)
  use("neovim/nvim-lspconfig")
  -- Highlight current parameter during signature help
  use("ray-x/lsp_signature.nvim")
  -- Completion
  use({
    "hrsh7th/nvim-cmp",
    requires = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-calc",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-vsnip",
      "andersevenrud/cmp-tmux",
    },
  })
  -- Pretty list of diagnostics (quickfix with style)
  use({ "folke/trouble.nvim", requires = "kyazdani42/nvim-web-devicons" })
  -- Show a lightbulb sign if a code action is available for the current line
  use("kosayoda/nvim-lightbulb")
  -- Progress bar/window for LSP servers
  use("j-hui/fidget.nvim")
  -- Use other sources for LSP actions
  -- Mainly formatting Lua - not part of the language server for some reason
  use({ "jose-elias-alvarez/null-ls.nvim" })
  -- Rust integrations
  use({ "simrat39/rust-tools.nvim", requires = "nvim-lua/plenary.nvim" })
  -- Schemas for JSON files to complete/display configurations options
  use("b0o/SchemaStore.nvim")
  -- Install language servers automatically
  use({ "williamboman/nvim-lsp-installer", config = [[require("config.lsp").setup()]] })

  -- Lua to recognise nvim API
  use("folke/lua-dev.nvim")

  -- :: Debugger
  use("mfussenegger/nvim-dap")
  use("mfussenegger/nvim-dap-python")
  use("theHamsta/nvim-dap-virtual-text")
  use({ "rcarriga/nvim-dap-ui", config = [[require("config.dap").setup()]] })

  -- :: Misc
  -- Commenting out code
  use({ "numToStr/Comment.nvim", config = [[require("config.comment").setup()]] })
  -- Smooth scrolling
  use({ "karb94/neoscroll.nvim", config = [[require("config.scrolling").setup()]] })
  -- Custom modes (continuous actions) e.g. resizing mode
  use({
    "anuvyklack/hydra.nvim",
    requires = "anuvyklack/keymap-layer.nvim",
    config = [[require("config.hydra").setup()]],
  })

  -- >>> Legacy/VimScript plugins <<<
  -- Because there are no alternatives yet or they are just too good
  -- Trying to replace as many as possible in the future, not just because they
  -- were written in VimScript, but many try to support very old versions of
  -- Vim, handling edge cases and potentially not using newer features.
  use("editorconfig/editorconfig-vim")
  -- Git (too good to be replaced any time soon)
  use("tpope/vim-fugitive")
  -- Show diff when using: git rebase --interactive
  use("hotwatermorning/auto-git-diff")
  -- Snippets (potential alternative: L3MON4D3/LuaSnip but currently not up to par)
  use("hrsh7th/vim-vsnip")
  use("rafamadriz/friendly-snippets")
  -- Expand keywords to HTML
  use("mattn/emmet-vim")
  -- Better search under cursor (smart case, visual *, etc.)
  use("haya14busa/vim-asterisk")
  -- Save/Open with sudo (replaces the tee sudo trick)
  use("lambdalisue/suda.vim")
  -- Undo tree
  use("mbbill/undotree")
  -- Align text
  use("godlygeek/tabular")
  -- Swap two regions of text
  use("tommcdo/vim-exchange")
  -- Manipulate surrounding parentheses, quotes, etc.
  -- I had used vim-surround for the longest time, but vim-sandwich is just superior.
  -- Better feedback (visual and timeout), interactive surroundings, func, double count, etc.
  -- I was reluctant because it maps `s`, but it does make it simpler to use, just need to get used to it.
  use("machakann/vim-sandwich")
  -- Run shell commands asynchronously
  use("skywind3000/asyncrun.vim")
  -- Live preview of markdown files
  use({ "iamcco/markdown-preview.nvim", run = "cd app & yarn install", ft = { "markdown" } })
  -- Generate Table of Contents (ToC) and automatically keep it update to date.
  use("mzlogin/vim-markdown-toc")
  -- Yank over SSH with ANSI OSC52 escape sequence
  use("ojroques/vim-oscyank")

  -- Fzf (fuzzy finder)
  -- Just too good compared to the alternatives.
  -- Biggest contender is Telescope, but from my testing it was frustrating in many regards. I like the tight
  -- integration with NeoVim internals (buffers, marks, jumps, etc.) but when it comes to external commands
  -- it ranges from being full of small annoyances to becoming unusable.
  -- The following are some of the problems I encountered:
  --    Matching is odd, often it shows more matches after further narrowing it down (WHY?) and some searches
  --     don't filter anything at all.
  --    When the list changes it seems jumpy and delayed, especially when it grows back (previous point)
  --    Syntax highlighting is nice, but quickly going through the files in the list is slow because of it.
  --    Searching a lot of files or grepping can freeze (even with native fzy)
  --    Multi select when opening files doesn't open all selected files (selection does nothing)
  --    When a command cannot open a list (`spell_suggest` for example never worked for me) it just enters
  --     insert mode for no reason and overwrites text and messes with the undo history (can't undo correctly)
  --    Creates a million buffers (3 for the UI and one per file in the list), that seems irrelevant but I use
  --     and display the buffer numbers directly and don't like being at 200+ after like two fuzzy searches.
  -- Telescope looks nice, but it falls short in the most basic functionalities, which are my reasons for having
  -- a fuzzy finder in the first place (namely opening files quickly). All the bonus features in the world are useless
  -- if the basics don't work properly.
  use({
    "junegunn/fzf.vim",
    requires = {
      {
        "junegunn/fzf",
        run = function()
          vim.fn["fzf#install"]()
        end,
      },
    },
  })
end)

require("config.legacy").setup()
