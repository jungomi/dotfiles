return {
  -- >>> Legacy/VimScript plugins <<<
  -- Because there are no alternatives yet or they are just too good
  -- Trying to replace as many as possible in the future, not just because they
  -- were written in VimScript, but many try to support very old versions of
  -- Vim, handling edge cases and potentially not using newer features.
  "editorconfig/editorconfig-vim",
  -- Git (too good to be replaced any time soon)
  "tpope/vim-fugitive",
  -- Show diff when using: git rebase --interactive
  "hotwatermorning/auto-git-diff",
  -- Snippets (potential alternative: L3MON4D3/LuaSnip but currently not up to par)
  {
    "hrsh7th/vim-vsnip",
    depdendencies = {
      "rafamadriz/friendly-snippets",
    },
  },
  -- Expand keywords to HTML
  "mattn/emmet-vim",
  -- Better search under cursor (smart case, visual *, etc.)
  "haya14busa/vim-asterisk",
  -- Save/Open with sudo (replaces the tee sudo trick)
  "lambdalisue/suda.vim",
  -- Undo tree
  "mbbill/undotree",
  -- Align text
  "godlygeek/tabular",
  -- Swap two regions of text
  "tommcdo/vim-exchange",
  -- Manipulate surrounding parentheses, quotes, etc.
  -- I had used vim-surround for the longest time, but vim-sandwich is just superior.
  -- Better feedback (visual and timeout), interactive surroundings, func, double count, etc.
  -- I was reluctant because it maps `s`, but it does make it simpler to use, just need to get used to it.
  "machakann/vim-sandwich",
  -- Run shell commands asynchronously
  "skywind3000/asyncrun.vim",
  -- Live preview of markdown files
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app & yarn install",
    ft = { "markdown" },
  },
  -- Generate Table of Contents (ToC) and automatically keep it update to date.
  "mzlogin/vim-markdown-toc",

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
  {
    "junegunn/fzf.vim",
    dependencies = {
      {
        "junegunn/fzf",
        run = function()
          vim.fn["fzf#install"]()
        end,
      },
    },
  },
}
