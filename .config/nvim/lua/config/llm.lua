local code_companion = require("codecompanion")
local llm_mappings = require("mappings.llm")
local borders = require("borders")

local M = {}

function M.setup()
  code_companion.setup({
    extensions = {
      mcphub = {
        callback = "mcphub.extensions.codecompanion",
        opts = {
          show_result_in_chat = true,
          make_vars = true,
          make_slash_commands = true,
        },
      },
    },
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

  -- local NoiceCodecompanionProgress = require("utils.noice_codecompanion_progress")
  -- NoiceCodecompanionProgress.setup()
end

return M
