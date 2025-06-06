local code_companion = require("codecompanion")
local code_compnaion_extensions = require("codecompanion._extensions")
local llm_mappings = require("mappings.llm")
local borders = require("borders")

local M = {
  -- Extensions that should not be loaded on startup, since they might use unnecessary resources,
  -- even though they are rarely used in the first place.
  lazy_extensions = {
    mcphub = {
      callback = "mcphub.extensions.codecompanion",
      opts = {
        show_result_in_chat = true,
        make_vars = true,
        make_slash_commands = true,
      },
    },
  },
}

function M.load_lazy_extensions()
  for name, cfg in pairs(M.lazy_extensions) do
    code_compnaion_extensions.load_extension(name, cfg)
  end
end

function M.setup()
  code_companion.setup({
    extensions = {},
    display = {
      chat = {
        intro_message = "Press g? to show key maps",
        window = {
          border = borders.default,
          opts = {
            cursorline = true,
            signcolumn = "yes",
          },
        },
      },
    },
    strategies = {
      chat = {
        keymaps = {
          options = {
            modes = { n = "g?" },
          },
          close = {
            modes = {
              n = { "<C-c>", "gq" },
              i = "<C-c>",
            },
          },
          -- Stupid that so many tools over write { and }, as that is my vertical naviation...
          next_chat = {
            modes = { n = "]c" },
          },
          previous_chat = {
            modes = { n = "[c" },
          },
        },
      },
      inline = {
        keymaps = {
          accept_change = {
            modes = { n = "<leader>ca" },
          },
          reject_change = {
            modes = { n = "<leader>cr" },
          },
        },
      },
    },
  })

  llm_mappings.enable_mappings()
end

return M
