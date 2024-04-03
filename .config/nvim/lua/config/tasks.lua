local overseer = require("overseer")
local task_editor = require("overseer.task_editor")

local M = {}

function M.watch_cmd(cmd, files)
  -- Files to watch, defaults to the current file.
  files = files or { vim.fn.expand("%:p") }
  local task = overseer.new_task({
    cmd = vim.fn.expandcmd(cmd),
    components = {
      { "display_duration", detail_level = 2 },
      { "on_output_summarize", max_lines = 8 },
      "default",
    },
  })
  task:add_component({ "restart_on_save", paths = files })
  task:start()
  overseer.open({ enter = false })
end

function M.run_and_open(opts)
  overseer.run_template(opts, function(task)
    if task then
      overseer.open({ enter = false })
    end
  end)
end

function M.build_task_and_open(opts)
  opts = opts or { name = "Task Name", cmd = "ls" }
  local task = overseer.new_task(opts)
  task_editor.open(task, function(result)
    if result then
      task:start()
      overseer.open({ enter = false })
    else
      task:dispose()
    end
  end)
end

return M
