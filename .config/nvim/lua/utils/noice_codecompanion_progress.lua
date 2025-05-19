local Config = require("noice.config")
local Format = require("noice.text.format")
local Message = require("noice.message")
local Manager = require("noice.message.manager")
local Router = require("noice.message.router")
local Util = require("noice.util")

local autocmd_utils = require("utils.autocmd")

-- Adapted from noice.lsp.progress.
local NoiceCodecompanionProgress = {}

---@type table<string, NoiceMessage>
NoiceCodecompanionProgress._progress = {}

function NoiceCodecompanionProgress.progress(request, opts)
  opts = opts or {}
  local id = request.data.id
  local message = NoiceCodecompanionProgress._progress[id]
  if not message then
    message = Message("lsp", "progress")
    message.opts.progress = {
      client_id = "client " .. id,
      client = NoiceCodecompanionProgress.llm_name(request.data.adapter),
      id = id,
    }
    NoiceCodecompanionProgress._progress[id] = message
  end
  message.opts.progress = vim.tbl_deep_extend("force", message.opts.progress, opts)

  if message.opts.progress.kind == "end" then
    vim.defer_fn(function()
      NoiceCodecompanionProgress.close(id)
    end, 100)
  end

  NoiceCodecompanionProgress.update()
end

function NoiceCodecompanionProgress.close(id)
  local message = NoiceCodecompanionProgress._progress[id]
  if message then
    NoiceCodecompanionProgress.update()
    Router.update()
    Manager.remove(message)
    NoiceCodecompanionProgress._progress[id] = nil
  end
end

function NoiceCodecompanionProgress._update()
  if not vim.tbl_isempty(NoiceCodecompanionProgress._progress) then
    for id, message in pairs(NoiceCodecompanionProgress._progress) do
      if message.opts.progress.kind == "end" then
        Manager.add(Format.format(message, Config.options.lsp.progress.format_done))
      else
        Manager.add(Format.format(message, Config.options.lsp.progress.format))
      end
    end
  end
end

function NoiceCodecompanionProgress.llm_name(adapter)
  local parts = {}
  table.insert(parts, adapter.formatted_name)
  if adapter.model and adapter.model ~= "" then
    table.insert(parts, "(" .. adapter.model .. ")")
  end
  return table.concat(parts, " ")
end

function NoiceCodecompanionProgress.exit_status(request)
  if request.data.status == "success" then
    return "Completed"
  elseif request.data.status == "error" then
    return "Error"
  else
    return "Cancelled"
  end
end

function NoiceCodecompanionProgress.update()
  error("should never be called")
end

function NoiceCodecompanionProgress.setup()
  NoiceCodecompanionProgress.update =
    Util.interval(Config.options.lsp.progress.throttle, NoiceCodecompanionProgress._update, {
      enabled = function()
        return not vim.tbl_isempty(NoiceCodecompanionProgress._progress)
      end,
    })

  autocmd_utils.create_augroups({
    noice_codecompnaion_progress = {
      {
        event = "User",
        pattern = "CodeCompanionRequestStarted",
        callback = function(request)
          NoiceCodecompanionProgress.progress(request, { title = "Codecompanion", kind = "start" })
        end,
      },
      {
        event = "User",
        pattern = "CodeCompanionRequestFinished",
        callback = function(request)
          NoiceCodecompanionProgress.progress(request, {
            title = NoiceCodecompanionProgress.exit_status(request),
            kind = "end",
          })
        end,
      },
    },
  })
end

return NoiceCodecompanionProgress
