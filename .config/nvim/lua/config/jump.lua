local flash = require("flash")
local jump_mappings = require("mappings.jump")

local M = {}

function M.setup()
  flash.setup({
    label = {
      after = false,
      before = true,
    },
    highlight = {
      backdrop = false,
    },
    modes = {
      search = {
        -- Don't want to have labels on the regular search, while it is quite cool and makes it especially easy to use
        -- (not new keybind, just an additional feature during the search), there is one crucial drawback, namely that
        -- it will automatically jump (and cancel the search afterwards) if something is typed where it hits a label
        -- (i.e. when the search term doesn't exist, but part of it did, so the label selected that instead of
        -- continuing to narrow the search).
        -- I would even prefer this to the regular jump (can be used for operator pending as well), just because you can
        -- see what you typed for the search. But that should only activate from a mapping.
        enabled = false,
      },
      char = {
        highlight = {
          backdrop = false,
          label = {
            -- Need to explicitely disable it here, otherwise there is one character before that is highlighted even
            -- though there is no label there.
            before = false,
          },
        },
      },
    },
  })

  jump_mappings.enable_mappings()
end

return M
