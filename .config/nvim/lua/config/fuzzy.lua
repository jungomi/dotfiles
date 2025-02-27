local fzf = require("fzf-lua")
local fzf_actions = require("fzf-lua.actions")
local fuzzy_mappings = require("mappings.fuzzy")
local icons = require("icons")
local borders = require("borders")

local M = {}

function M.setup()
  fzf.setup({
    fzf_opts = {
      ["--layout"] = "default",
      ["--separator"] = "―",
      ["--marker"] = icons.dot,
      ["--pointer"] = icons.arrow.thick,
      -- Don't apply bolds, because they cannot be reset, so adding them manually to only the parts that make sense.
      ["--no-bold"] = true,
    },
    fzf_colors = {
      -- When "fg" or "bg" is encountered in the list, it will take the component from the next Highlight Group.
      -- so { "fg", "Comment", "bold" } means { "<fg-colour-of-Comment>", "bold" }
      ["fg"] = { "fg", "Normal" },
      ["bg"] = { "bg", "WinBar" },
      ["fg+"] = { "fg", "Normal" },
      ["bg+"] = { "bg", "Search" },
      ["hl"] = { "fg", "Special", "bold", "italic" },
      ["hl+"] = { "fg", "Special", "bold", "italic" },
      ["info"] = { "fg", "Comment" },
      ["prompt"] = { "fg", "Function", "bold" },
      ["pointer"] = { "fg", "Normal" },
      ["marker"] = { "bg", "IncSearch" },
      ["spinner"] = { "fg", "Comment", "bold" },
      ["header"] = { "fg", "Comment" },
      ["gutter"] = { "bg", "WinBar" },
    },
    winopts = {
      border = borders.default,
      height = 0.4,
      width = 1.0,
      row = 1.0,
      col = 0.5,
    },
    keymap = {
      -- These override the default tables completely so you need to specify every single one, can't just add something
      -- or set something to false.
      builtin = {
        ["<F1>"] = "toggle-help",
        ["<F2>"] = "toggle-fullscreen",
        -- Only valid with the 'builtin' previewer
        ["<C-w>"] = "toggle-preview-wrap",
        ["<C-p>"] = "toggle-preview",
        -- Rotate preview clockwise/counter-clockwise
        ["<F5>"] = "toggle-preview-ccw",
        ["<F6>"] = "toggle-preview-cw",
        ["<M-j>"] = "preview-page-down",
        ["<M-k>"] = "preview-page-up",
        ["<M-r>"] = "preview-page-reset",
      },
    },
    actions = {
      -- These override the default tables completely so you need to specify every single one, can't just add something
      -- or set something to false.
      files = {
        ["default"] = fzf_actions.file_edit_or_qf,
        ["ctrl-x"] = fzf_actions.file_split,
        ["ctrl-v"] = fzf_actions.file_vsplit,
        ["ctrl-t"] = fzf_actions.file_tabedit,
        -- Show hidden files / git ignored files
        ["ctrl-h"] = { fzf_actions.toggle_hidden },
        ["ctrl-g"] = { fzf_actions.toggle_ignore },
      },
      buffers = {
        ["default"] = fzf_actions.buf_edit,
        ["ctrl-x"] = fzf_actions.buf_split,
        ["ctrl-v"] = fzf_actions.buf_vsplit,
        ["ctrl-t"] = fzf_actions.buf_tabedit,
      },
    },
    defaults = {
      -- Open the quickfix list in Trouble instead of the regular qf window.
      copen = "Trouble qflist open",
    },
    git = {
      files = {
        prompt = string.format("Git %s ", icons.git.branch),
      },
      status = {
        prompt = string.format("Git Status %s ", icons.git.branch),
        -- Not sure whether I want to use `delta` or not.
        -- preview_pager = false,
        actions = {
          -- So now you have to set them to false to disable them, rather than just overwriting it as above...
          -- In the case where I wanted to change 1 or 2, I needed to copy the whole thing, now I don't want any of them
          -- and I need to copy the whole thing again. Literally the opposite of what I wanted.
          -- Terrible defaults, also don't want to have any actions here for Git.
          ["right"] = false,
          ["left"] = false,
          ["ctrl-x"] = false,
        },
      },
    },
    grep = {
      prompt = string.format("Rg %s ", icons.magnify),
      input_prompt = string.format("Rg %s ", icons.magnify),
      no_header_i = true,
      actions = {
        -- Live grep (edit the grep search term)
        ["ctrl-r"] = { fzf_actions.grep_lgrep },
        -- Show hidden files / git ignored files
        ["ctrl-h"] = { fzf_actions.toggle_hidden },
        ["ctrl-g"] = { fzf_actions.toggle_ignore },
      },
    },
    oldfiles = {
      prompt = string.format("History %s ", icons.lsp_kind.File),
    },
    buffers = {
      prompt = string.format("Buffers %s ", icons.window),
      no_header_i = true,
      actions = {
        -- Given as a table, so that fzf doesn't close.
        ["ctrl-q"] = { fn = fzf_actions.buf_del, reload = true },
      },
    },
    lines = {
      prompt = "Lines  ",
    },
    blines = {
      prompt = "Lines (Buffer)  ",
    },
    lsp = {
      prompt_postfix = string.format(" %s ", icons.lsp_kind.Field),
      symbols = {
        -- Prefer my icons where applicable (to be consistent)
        symbol_icons = icons.lsp_kind,
      },
      code_actions = {
        prompt = string.format("Code Actions %s ", icons.bulb),
      },
    },
    diagnostics = {
      prompt = string.format("Diagnostics %s ", icons.lsp_kind.Constructor),
    },
    marks = {
      prompt = string.format("Marks %s ", icons.location),
    },
  })

  -- Configure vim.ui.select differently from the regular layout.
  -- I prefer this in the middle (top-down) rather than the bottom (bottom-up) and also smaller.
  fzf.register_ui_select({
    fzf_opts = {
      ["--layout"] = "reverse",
    },
    winopts = {
      height = 0.6,
      width = 0.6,
      row = 0.5,
      col = 0.5,
    },
  }, true)

  fuzzy_mappings.enable_mappings()
end

return M
