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
    border = "single",
    -- These icons need to be redefined as the defaults are somehow not renedered properly.
    -- Probably should look at fixing the Nerd font.
    icons = {
      cmd = " ",
      event = "",
      lazy = " ",
      start = "",
    },
  },
})

require("config.legacy").setup()

return {}
