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
})

require("config.legacy").setup()

return {}
