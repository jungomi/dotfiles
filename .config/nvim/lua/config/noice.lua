local noice = require("noice")
local notify = require("notify")
local colours = require("theme").colours
local icons = require("icons")
local borders = require("borders")

local M = {}

function M.setup()
  notify.setup({
    background_colour = colours.red,
    render = "default",
    stages = "fade",
    timeout = 1500,
    minimum_width = 20,
    fps = 60,
    on_open = function(win)
      vim.api.nvim_win_set_config(win, { zindex = 50 })
    end,
  })

  noice.setup({
    cmdline = {
      format = {
        search_down = { icon = string.format("%s %s", icons.magnify, icons.double_angle.down) },
        search_up = { icon = string.format("%s %s", icons.magnify, icons.double_angle.up) },
      },
    },
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
      progress = {
        throttle = 1000 / 60,
      },
    },
    presets = {
      bottom_search = false,
      command_palette = true,
      long_message_to_split = true,
      lsp_doc_border = true,
    },
    throttle = 1000 / 60,
    routes = {
      -- Undo / Redo Messages send to mini instead of notify
      {
        filter = {
          event = "msg_show",
          kind = "",
          -- X fewer|more line[s]
          find = "^%d+ %w+ lines?",
        },
        view = "mini",
      },
      {
        filter = {
          event = "msg_show",
          kind = "",
          find = "^%d+ lines?",
        },
        view = "mini",
      },
      {
        filter = {
          event = "msg_show",
          kind = "",
          find = "^%d+ changes?",
        },
        view = "mini",
      },
      {
        filter = {
          event = "msg_show",
          kind = "",
          find = "^Already at %w+ change",
        },
        view = "mini",
      },
      -- Written file
      {
        filter = {
          event = "msg_show",
          kind = "",
          find = "%[w%]$",
        },
        view = "mini",
      },
    },
    views = {
      cmdline_popup = {
        border = {
          style = borders.hidden,
          padding = { 1, 2 },
        },
      },
      cmdline_popupmenu = {
        border = {
          style = borders.hidden,
          padding = { 0, 2, 1, 2 },
        },
        win_options = {
          -- For some reason the highlight group is not applied correctly if it's not specified here.
          -- Don't know why, that should be default, but whatever.
          winhighlight = { Normal = "NoiceCmdlinePopup" },
        },
      },
      confirm = {
        border = {
          style = borders.hidden,
          padding = { 1, 2 },
        },
      },
      hover = {
        border = {
          style = borders.hover,
          padding = { 0, 0 },
        },
      },
    },
  })
end

return M
