-- Experimental Lua module loader, which uses byte-compilation cache.
-- This makes loading plugins faster on subsequent loads.
if vim.loader then
  vim.loader.enable()
end

require("options")
require("mappings")
vim.cmd("colorscheme mine")
-- Load plugins
require("load_plugins")
-- Autocommands need to be loaded after the plugins are loaded, as they import them.
require("autocommands")
