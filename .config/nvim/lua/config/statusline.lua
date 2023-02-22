local lua_line = require("lualine")
local colours = require("theme").colours
local noice = require("noice")
local buffer_state = require("bufferline.state")

local M = {}

local path_style = {
  filename = 0,
  relative = 1,
  absolute = 2,
}

local function buf_nr()
  -- The buffer line state needs time to be initialised so when launching nvim it will be nil,
  -- in order to show something meaningful 1 is used instead, as that is hopefully the only time
  -- this occurs and on launch it will always be the first buffer.
  return string.format("樂%d ", buffer_state.current_element_index or 1)
end

-- Shows indentation settings and trailing whitespaces
-- 2 Spaces => Tab:2
-- Tabs => Tab:
-- 2 Spaces, but file contains tabs => Tab:2/
-- Tabs, but file contains spaces => Tab:/2
-- Trailing whitespace => Tab:2
local function tabs_and_spaces()
  local expand_tab = vim.opt.expandtab:get()
  local num_spaces = vim.opt.shiftwidth:get()
  local has_tabs = vim.fn.search("^\t", "nw") > 0
  local has_spaces = vim.fn.search("^ ", "nw") > 0
  local has_trailing = vim.fn.search([[\s\+$]], "nw") > 0

  local parts = {}
  if has_trailing then
    table.insert(parts, "")
  end
  table.insert(parts, "Tab:")
  if expand_tab then
    table.insert(parts, num_spaces)
    -- Indenting with spaces, but file has tabs for indentation
    if has_tabs then
      table.insert(parts, "/")
    end
  else
    table.insert(parts, "")
    -- Indenting with tabs, but file has spaces for indentation
    if has_spaces then
      table.insert(parts, "/")
      table.insert(parts, num_spaces)
    end
  end

  return table.concat(parts)
end

local function left()
  return {
    { buf_nr },
    {
      "filename",
      path = path_style.relative,
      symbols = {
        modified = " ",
        readonly = " ",
      },
    },
    {
      "diagnostics",
      sources = { "nvim_diagnostic" },
      sections = { "error", "warn", "info", "hint" },
      symbols = {
        error = " ",
        warn = " ",
        info = " ",
        hint = " ",
      },
    },
  }
end

local function right()
  return {
    {
      noice.api.status.mode.get,
      cond = noice.api.status.mode.has,
      color = { fg = colours.purple, gui = "bold" },
    },
    { tabs_and_spaces },
    "fileformat",
    "encoding",
    { "filetype", colored = false },
    "location",
    "progress",
  }
end

local function fill_separator()
  -- A separator to fill up the space between two components
  return "%="
end

-- Custom statusline for DAP windows
local function dap_statusline()
  return {
    sections = {
      lualine_c = { { fill_separator }, { "filename", file_status = false } },
      lualine_x = {},
    },
    filetypes = { "dapui_breakpoints", "dapui_scopes", "dapui_stacks", "dapui_watches" },
  }
end

local function dap_repl_name()
  return "DAP REPL"
end

local function dap_repl_statusline()
  return {
    sections = {
      lualine_c = { { buf_nr }, { dap_repl_name } },
      lualine_x = {
        "location",
        "progress",
      },
    },
    filetypes = { "dap-repl" },
  }
end

function M.setup()
  lua_line.setup({
    options = {
      globalstatus = true,
      -- Disable separators
      component_separators = "",
      section_separators = "",
      theme = {
        -- lualine_c is used as left and lualine_x as right
        normal = {
          c = { fg = colours.dark_grey, bg = colours.dark_border, gui = "bold" },
        },
        inactive = {
          c = { fg = colours.grey, bg = colours.cursor_line },
        },
      },
    },
    sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = left(),
      lualine_x = right(),
      lualine_y = {},
      lualine_z = {},
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = left(),
      lualine_x = right(),
      lualine_y = {},
      lualine_z = {},
    },
    extensions = { dap_statusline(), dap_repl_statusline() },
  })
end

return M
