local icons = require("icons")

local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazy_path) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazy_path,
  })
end
vim.opt.rtp:prepend(lazy_path)

local lazy = require("lazy")
lazy.setup("plugins", {
  install = {
    colorscheme = { "mine" },
  },
  ui = {
    border = "rounded",
    -- These icons need to be redefined as the defaults are somehow not renedered properly.
    -- Probably should look at fixing the Nerd font.
    icons = {
      cmd = icons.terminal,
      event = icons.lightning,
      lazy = icons.pad_right(icons.lsp_kind.Module, 1),
      start = icons.triangle.normal,
    },
  },
})

require("config.legacy").setup()

return {}
