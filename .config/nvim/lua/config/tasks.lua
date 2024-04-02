local overseer = require("overseer")

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
end

return M
