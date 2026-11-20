local map_utils = require("utils.map")
local map = map_utils.map
local nmap = map_utils.nmap

return {
  -- >>> Legacy/VimScript plugins <<<
  -- Because there are no alternatives yet or they are just too good
  -- Trying to replace as many as possible in the future, not just because they
  -- were written in VimScript, but many try to support very old versions of
  -- Vim, handling edge cases and potentially not using newer features.

  -- Save/Open with sudo (replaces the tee sudo trick)
  {
    "lambdalisue/suda.vim",
    keys = function()
      nmap("<leader>sw", "<Cmd>w suda://%<CR>", { desc = "Save with sudo" })
    end,
  },
}
