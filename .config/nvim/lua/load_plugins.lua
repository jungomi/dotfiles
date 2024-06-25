local icons = require("icons")
local borders = require("borders")

local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazy_path) then
  vim
    .system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazy_path,
    })
    :wait()
end
vim.opt.rtp:prepend(lazy_path)

local lazy = require("lazy")
lazy.setup({
  spec = {
    -- Plugins are in defined in the plugins/ directory
    { import = "plugins" },
  },
  install = {
    colorscheme = { "mine" },
  },
  ui = {
    border = borders.default,
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
