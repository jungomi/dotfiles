local lsp_endhints = require("lsp-endhints")
local autocmd_utils = require("utils.autocmd")
local str_utils = require("utils.str")

---@class InlayHints
---@field enabled boolean Whether the inlay hints are enabled
---@field at_end boolean Whether the inlay hints are displayed at the end of the line, otherwise inline.
local inlay_hints = {
  enabled = true,
  at_end = true,
}

---@alias InlayHintsState
---| "disabled" Inlay hints are disabled
---| "end" Inlay hints are displayed at the end of the line
---| "inline" Inlay hints are displayed inline

---@return InlayHintsState
function inlay_hints:state()
  if self.enabled then
    if self.at_end then
      return "end"
    else
      return "inline"
    end
  else
    return "disabled"
  end
end

---@param state InlayHintsState New state to set for the inlay hints
function inlay_hints:set_state(state)
  if state == "end" then
    self:enable(true)
  elseif state == "inline" then
    self:enable(false)
  else
    self:disable()
  end
end

---Enable inlay hints.
---If `at_end` is not specified, it will enable it with the current configuration, otherwise
---it will set it to the value given.
---@param at_end? boolean Whether to display them at the end.
function inlay_hints:enable(at_end)
  self.enabled = true
  if at_end ~= nil then
    self.at_end = at_end
  end
  if self.at_end then
    lsp_endhints.enable()
  else
    lsp_endhints.disable()
  end
  vim.lsp.inlay_hint.enable(true)
end

---Disable inlay hints.
function inlay_hints:disable()
  self.enabled = false
  vim.lsp.inlay_hint.enable(false)
  lsp_endhints.disable()
end

---Toggle inlay hints.
function inlay_hints:toggle()
  if self.enabled then
    self:disable()
  else
    self:enable()
  end
end

-- This is not a method, because that one is used in mappings, which can be used directly, rather than having
-- to create an anonymous function that calls the method.
---Cycle through the modes in the order: disabled, inline, at-end
function inlay_hints.cycle()
  if inlay_hints.enabled then
    if inlay_hints.at_end then
      inlay_hints:disable()
    else
      inlay_hints:enable(true)
    end
  else
    inlay_hints:enable(false)
  end
end

---Register the autocommand to toggle inlay hints when entering/exiting insert mode if they are shown inline.
function inlay_hints.register_autocmd()
  autocmd_utils.create_augroups({
    inlay_hints = {
      -- Inlay hints are really annoying in insert and visual modes. For example, in insert mode it makes the cursor
      -- jump ahead when the parameter is added as virtual text. So the easiest is to just disable them during these
      -- modes and reenable them when exiting.
      {
        event = "ModeChanged",
        pattern = "*",
        callback = function()
          local old_mode = vim.v.event.old_mode
          local new_mode = vim.v.event.new_mode
          if inlay_hints.at_end then
            -- Don't do anything if the hints are shown at the end.
            return
          end
          if str_utils.starts_with_one_of(new_mode, { "i", "v", "V", "" }) then
            inlay_hints:disable()
          elseif str_utils.starts_with_one_of(old_mode, { "i", "v", "V", "" }) then
            inlay_hints:enable()
          end
        end,
        desc = "Disable inlay hints in visual and insert mode",
      },
    },
  })
end

---Clear the autocommand to toggle inlay hints.
function inlay_hints.clear_autocmd()
  autocmd_utils.create_augroups({
    inlay_hints = {},
  })
end

return inlay_hints
