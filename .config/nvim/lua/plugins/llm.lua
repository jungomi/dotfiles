local borders = require("borders")
local nmap = require("utils.map").nmap

-- Extensions that should not be loaded on startup, since they might use unnecessary resources,
-- even though they are rarely used in the first place.
local lazy_extensions = {
  mcphub = {
    callback = "mcphub.extensions.codecompanion",
    opts = {
      show_result_in_chat = true,
      make_vars = true,
      make_slash_commands = true,
    },
  },
}

local function load_lazy_extensions()
  local code_companion_extensions = require("codecompanion._extensions")
  for name, cfg in pairs(lazy_extensions) do
    code_companion_extensions.load_extension(name, cfg)
  end
  local names = vim
    .iter(lazy_extensions)
    :map(function(name)
      return name
    end)
    :join(", ")
  vim.notify(string.format("Loaded extensions: %s", names))
end

local codecompanion_spec = {
  "olimorris/codecompanion.nvim",
  config = function()
    require("codecompanion").setup({
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
  end,
  keys = function()
    nmap("<leader>cc", "<CMD>CodeCompanionChat<CR>", { desc = "Code Companion » Chat" })
    nmap("<leader>ci", "<CMD>CodeCompanion<CR>", { desc = "Code Companion » Inline" })
    nmap("<leader>ca", "<CMD>CodeCompanionActions<CR>", { desc = "Code Companion » Actions" })
    nmap("<leader>cm", load_lazy_extensions, { desc = "Code Companion » Load lazy extensions" })
  end,
}

return {
  codecompanion_spec,
  {
    "zbirenbaum/copilot.lua",
    opts = {
      server_opts_overrides = {
        settings = {
          telemetry = {
            telemetryLevel = "off",
          },
        },
      },
    },
  },
  {
    "ravitemer/mcphub.nvim",
    -- Lazy load, since that starts a node server that uses a lot of unnecessary memory.
    -- I don't care for MCP most of the time, and if I want to use them I'll just start them.
    -- Also works when codecompanion.nvim registers the extension.
    opts = {
      -- Do not delay shutting down the server. There is no reason for me to keep it alive after exiting neovim.
      shutdown_delay = 0,
    },
  },
}
