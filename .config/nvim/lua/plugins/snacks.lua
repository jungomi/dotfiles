local borders = require("borders")

local M = {
  -- Collection of small QoL plugins
  "folke/snacks.nvim",
}

function M.config()
  require("snacks").setup({
    bigfile = { enabled = true },
    quickfile = { enabled = false },
    image = {
      enabled = true,
    },
    notifier = {
      enabled = true,
      timeout = 3000,
      margin = {
        top = 1,
      },
      style = function(buf, notif, ctx)
        -- This was copied from "snacks.notifier.styles.compact", but since that is not exposed, there is no other way
        -- to just extend it.
        -- It is specifically to modify a render issue with the stautscolumn, for which no configuration option seems
        -- to do the job.
        local title = vim.trim(notif.icon .. " " .. (notif.title or ""))
        if title ~= "" then
          ctx.opts.title = { { " " .. title .. " ", ctx.hl.title } }
          ctx.opts.title_pos = "center"
        end
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(notif.msg, "\n"))
        -- Additions:
        -- Set the statuscolumn to the same colour as the background.
        ctx.opts.wo.winhighlight = ctx.opts.wo.winhighlight .. ",LineNr:Normal"
      end,
    },
    statuscolumn = { enabled = false },
    words = { enabled = false },
    styles = {
      notification = {
        zindex = 50,
        wo = {
          winblend = 0,
          wrap = true,
        },
      },
      ["notification.history"] = {
        width = 0.8,
        border = borders.default,
        wo = {
          winhighlight = "Normal:NormalFloat",
          number = false,
          signcolumn = "no",
        },
      },
    },
  })
end

return M
