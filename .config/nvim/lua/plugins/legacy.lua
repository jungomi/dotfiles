local map_utils = require("utils.map")
local map = map_utils.map
local nmap = map_utils.nmap

return {
  -- >>> Legacy/VimScript plugins <<<
  -- Because there are no alternatives yet or they are just too good
  -- Trying to replace as many as possible in the future, not just because they
  -- were written in VimScript, but many try to support very old versions of
  -- Vim, handling edge cases and potentially not using newer features.

  -- Better search under cursor (smart case, visual *, etc.)
  {
    "haya14busa/vim-asterisk",
    keys = function()
      map("", "*", "<Plug>(asterisk-*)", { remap = true, desc = "Search » Forward" })
      map("", "#", "<Plug>(asterisk-#)", { remap = true, desc = "Search » Backward" })
      map("", "g*", "<Plug>(asterisk-g*)", { remap = true, desc = "Search » Forward (not exact)" })
      map("", "g#", "<Plug>(asterisk-g#)", { remap = true, desc = "Search » Backward (not exact)" })
      map("", "z*", "<Plug>(asterisk-z*)", { remap = true, desc = "Search » Forward (stay)" })
      map("", "gz*", "<Plug>(asterisk-gz*)", { remap = true, desc = "Search » Forward (stay - not exact)" })
      map("", "z#", "<Plug>(asterisk-z#)", { remap = true, desc = "Search » Backward (stay)" })
      map("", "gz#", "<Plug>(asterisk-gz#)", { remap = true, desc = "Search » Backward (stay - not exact)" })
    end,
  },

  -- Save/Open with sudo (replaces the tee sudo trick)
  {
    "lambdalisue/suda.vim",
    keys = function()
      nmap("<leader>sw", "<Cmd>w suda://%<CR>", { desc = "Save with sudo" })
    end,
  },


  -- Align text
  "godlygeek/tabular",

  -- Generate Table of Contents (ToC) and automatically keep it update to date.
  "mzlogin/vim-markdown-toc",
}
