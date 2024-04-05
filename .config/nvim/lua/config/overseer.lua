local overseer = require("overseer")
local overseer_mappings = require("mappings.overseer")
local tasks = require("config.tasks")
local gitlab_ci = require("config.tasks.gitlab_ci")

local M = {}

function M.register_tasks()
  overseer.register_template(gitlab_ci.template_provider)
end

function M.setup()
  overseer.setup({
    task_list = {
      default_detail = 2,
      direction = "bottom",
      min_height = 12,
      min_width = { 60, 0.1 },
      bindings = {
        ["<CR>"] = "RunAction",
        ["gq"] = "Close",
        ["o"] = "Edit",
        ["p"] = "TogglePreview",
        ["<C-v>"] = "OpenVsplit",
        ["<C-x>"] = "OpenSplit",
        ["<C-e>"] = false,
        ["<C-l>"] = false,
        ["<C-h>"] = false,
        ["<C-k>"] = false,
        ["<C-j>"] = false,
        ["<C-u>"] = "ScrollOutputUp",
        ["<C-d>"] = "ScrollOutputDown",
        ["x"] = "<Cmd>OverseerQuickAction dispose<CR>",
        ["r"] = "<Cmd>OverseerQuickAction restart<CR>",
      },
    },
    form = {
      win_opts = {
        winblend = 0,
      },
    },
  })

  vim.api.nvim_create_user_command("RunWatch", function(params)
    tasks.watch_cmd(params.args)
  end, {
    desc = "Run and watch a shell command as an Overseer task",
    nargs = "*",
    complete = "shellcmd",
  })

  M.register_tasks()

  overseer_mappings.enable_mappings()
end

return M
