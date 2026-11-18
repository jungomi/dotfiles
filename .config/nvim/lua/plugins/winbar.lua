local colours = require("theme").colours
local icons = require("icons")

local M = {
  -- Show buffer name similar to a winbar but with floating window
  "b0o/incline.nvim",
}

local function get_diagnostics(props)
  local label = {}
  for severity, icon in pairs(icons.diagnostic) do
    local n = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity[string.upper(severity)] })
    if n > 0 then
      table.insert(label, { icon .. " " .. n .. " ", group = "Diagnostic" .. severity })
    end
  end
  return label
end

local function render(props)
  local dev_icons = require("nvim-web-devicons")
  local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
  local filetype_icon, colour = dev_icons.get_icon_color(name)
  local is_modified = vim.api.nvim_get_option_value("modified", { buf = props.buf })

  local out = get_diagnostics(props)
  if #out > 0 then
    table.insert(out, { icons.pad(icons.bufferline.separator, 1, 1), guifg = colours.grey })
  end
  table.insert(out, { filetype_icon, guifg = colour })
  table.insert(out, { " " })
  table.insert(out, { name })
  if is_modified then
    table.insert(out, { icons.pad_left(icons.modified, 2) })
  end
  return out
end

function M.config()
  -- Doesn't use winbar directly but creates a floating window version of it.
  -- It's nice because it doesn't use up a line just for the buffer info.
  require("incline").setup({
    window = {
      margin = { horizontal = 0, vertical = 0 },
      padding = 2,
      zindex = 100,
    },
    render = render,
  })
end

return M
