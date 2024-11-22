return {
  -- >>> Legacy/VimScript plugins <<<
  -- Because there are no alternatives yet or they are just too good
  -- Trying to replace as many as possible in the future, not just because they
  -- were written in VimScript, but many try to support very old versions of
  -- Vim, handling edge cases and potentially not using newer features.
  -- Better search under cursor (smart case, visual *, etc.)
  "haya14busa/vim-asterisk",
  -- Save/Open with sudo (replaces the tee sudo trick)
  "lambdalisue/suda.vim",
  -- Undo tree
  "mbbill/undotree",
  -- Align text
  "godlygeek/tabular",
  -- Live preview of markdown files
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app & yarn install",
    ft = { "markdown" },
  },
  -- Generate Table of Contents (ToC) and automatically keep it update to date.
  "mzlogin/vim-markdown-toc",
}
