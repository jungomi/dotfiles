local nmap = require("utils.map").nmap

local M = {
  -- Task runner
  "stevearc/overseer.nvim",
}

function M.register_tasks()
  local overseer = require("overseer")
  local gitlab_ci = require("utils.tasks.gitlab_ci")
  overseer.register_template(gitlab_ci.template_provider)
end

function M.config()
  local tasks = require("utils.tasks")

  require("overseer").setup({
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
        ["-"] = "DecreaseDetail",
        ["="] = "IncreaseDetail",
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
end

function M.keys()
  local overseer = require("overseer")
  local tasks = require("utils.tasks")

  nmap("<leader>ot", function()
    overseer.toggle({ enter = false })
  end, { desc = "Overseer » Toggle" })
  nmap("<leader>or", tasks.run_and_open, { desc = "Overseer » Run a task" })
  nmap("<leader>oc", tasks.build_task_and_open, { desc = "Overseer » Create a task with the builder" })
  nmap("<leader>oa", "<Cmd>OverseerTaskAction<CR>", { desc = "Overseer » Action" })
  nmap("<leader>ow", function()
    vim.ui.input({ prompt = "Watch Command", completion = "shellcmd" }, function(input)
      input = input or ""
      -- Do not execute it if the given string is empty
      if input ~= "" then
        tasks.watch_cmd(input)
      end
    end)
  end, {
    desc = "Overseer » Run and watch a shell command as a task",
  })
end

return M
