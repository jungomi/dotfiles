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
        -- Disable f / t / F / T as it breaks dot repeat, which is infuriating.
        -- Also I don't see the benefits of this as I disabled the multi line anyway.
        enabled = false,
        multi_line = false,
        label = {
          -- Need to explicitly disable it here, otherwise there is one character before that is highlighted even
          -- though there is no label there.
          before = false,
        },
        highlight = {
          backdrop = false,
        },
        -- Dynamic config options
        config = function(opts)
          -- Disable the labels after d/y with a motion.
          -- "no" is normal - operator pending mode
          opts.autohide = vim.fn.mode(true):find("no") and (vim.v.operator == "d" or vim.v.operator == "y")
        end,
      },
    },
  })

  jump_mappings.enable_mappings()
end

return M
