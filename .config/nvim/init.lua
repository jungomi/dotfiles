require("options")
require("mappings")
require("theme").load_theme()
-- Load plugins
require("load_plugins")
-- Autocommands need to be loaded after the plugins are loaded, as they import them.
require("autocommands")
