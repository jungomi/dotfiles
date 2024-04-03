local map_utils = require("utils.map")
local nmap = map_utils.nmap
local overseer = require("overseer")
local tasks = require("config.tasks")

local M = {}

function M.enable_mappings()
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
