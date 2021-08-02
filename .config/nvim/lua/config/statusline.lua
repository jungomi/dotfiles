local lua_line = require("lualine")
local colours = require("theme").colours
local dap = require("dap")

local M = {}

local path_style = {
  filename = 0,
  relative = 1,
  absolute = 2,
}

local function buf_nr()
  return string.format("樂%d ", vim.fn.bufnr())
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
      sources = { "nvim_lsp" },
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
      -- Disable separators
      component_separators = "",
      section_separators = "",
      theme = {
        -- lualine_c is used as left and lualine_x as right
        normal = {
          b = { fg = colours.statusline.text, bg = colours.bg, gui = "bold" },
          c = { fg = colours.statusline.text, bg = colours.statusline.active, gui = "bold" },
        },
        inactive = {
          b = { fg = colours.statusline.text, bg = colours.bg, gui = "bold" },
          c = { fg = colours.statusline.text, bg = colours.statusline.inactive },
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
