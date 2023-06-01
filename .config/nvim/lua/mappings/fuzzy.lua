local themes = require("telescope.themes")
local builtin = require("telescope.builtin")
local map_utils = require("utils.map")
local nmap = map_utils.nmap
local icons = require("icons")

local BOTTOM_THEME = themes.get_ivy({
  results_title = false,
  preview_title = false,
  sorting_strategy = "descending",
  -- Don't cycle from the last to first entry when reaching the end.
  scroll_strategy = "limit",
  -- Never jump automatically!
  -- Whenever there is only 1 result it just jumps instead of opening the finder, that's just annoying.
  jump_type = "never",
  layout_config = {
    height = 0.4,
    width = 0.9,
    prompt_position = "bottom",
    preview_cutoff = 0,
  },
  -- Don't want icons, just use the abbreviations
  git_icons = {
    added = "A",
    changed = "M",
    copied = "C",
    deleted = "-",
    renamed = "R",
    unmerged = "U",
    untracked = "?",
  },
})

function BOTTOM_THEME:with(opts)
  return vim.tbl_deep_extend("force", {}, self, opts)
end

function BOTTOM_THEME:prefix(pre)
  return self:with({ prompt_prefix = pre })
end

function BOTTOM_THEME:title(title)
  return self:with({ prompt_title = title })
end

-- Convenience for same title and prefix + icon (also icon can contain string.format parts)
-- It's the most common occurrence to have the prefix start with the title
function BOTTOM_THEME:fmt_icon(title, icon, ...)
  local prefix = title
  if icon then
    prefix = string.format("%s %s ", title, string.format(icon, ...))
  end
  return self:with({ prompt_title = title, prompt_prefix = prefix })
end

-- Extend the themes so it can be used with the command:
-- Telescope <picker> theme=mine
themes.mine = function(opts)
  return BOTTOM_THEME:with(opts)
end

local PALETTE_THEME = themes.get_dropdown({
  -- results_title = false,
  -- preview_title = false,
  -- sorting_strategy = "descending",
  layout_config = {
    height = 0.4,
    width = 0.8,
    -- prompt_position = "bottom",
  },
})

local function normalise_dir(path, shorten)
  local normalised = vim.fn.fnamemodify(path, ":~:.") .. "/"
  if shorten then
    normalised = vim.fn.pathshorten(normalised)
  end
  return normalised
end

-- Create the function with the picker for standard pickers where the title and icons are given.
local function fn_with_icon(picker, title, icon, ...)
  local theme = BOTTOM_THEME:fmt_icon(title, icon, ...)
  return function()
    picker(theme)
  end
end

local M = {}

function M.enable_mappings()
  nmap("<leader>ff", function()
    builtin.find_files(BOTTOM_THEME:prefix(normalise_dir(vim.fn.getcwd())):title("Files"))
  end, { desc = "Fuzzy » Files" })
  -- Config files
  nmap("<leader>fv", function()
    local path = vim.fn.stdpath("config")
    builtin.find_files(BOTTOM_THEME:with({ cwd = path }):prefix(normalise_dir(path)):title("Configs"))
  end, { desc = "Fuzzy » Configs" })
  -- History of recently opened files
  nmap("<leader>fh", fn_with_icon(builtin.oldfiles, "History", icons.lsp_kind.File), { desc = "Fuzzy » History" })
  nmap("<leader>fg", fn_with_icon(builtin.git_files, "Git", icons.git.branch), { desc = "Fuzzy » Git files" })
  -- Git status
  nmap("<leader>fs", fn_with_icon(builtin.git_status, "Git Status", icons.git.branch), { desc = "Fuzzy » Git status" })
  nmap("<leader>fb", fn_with_icon(builtin.buffers, "Buffers", icons.window), { desc = "Fuzzy » Buffers" })
  nmap("<leader>ft", fn_with_icon(builtin.tags, "Tags", icons.hash), { desc = "Fuzzy » Tags" })
  nmap("<leader>fl", fn_with_icon(builtin.current_buffer_fuzzy_find, "Lines", ""), { desc = "Fuzzy » Lines" })
  nmap("<leader>fm", fn_with_icon(builtin.marks, "Marks", icons.location), { desc = "Fuzzy » Marks" })
  nmap(
    "<leader>fq",
    fn_with_icon(builtin.diagnostics, "Diagnostics", icons.lsp_kind.Constructor),
    { desc = "Fuzzy » Diagnostics" }
  )
  nmap(
    "<leader>fd",
    fn_with_icon(builtin.lsp_definitions, "Definitions", icons.copyright),
    { desc = "Fuzzy » Definitions" }
  )
  nmap(
    "<leader>fr",
    fn_with_icon(builtin.lsp_references, "References", icons.lsp_kind.Reference),
    { desc = "Fuzzy » References" }
  )
  -- These incoming/outgoing calls are rarely supported, so far I've only seen it for Rust, but it's pretty nifty.
  nmap(
    "<leader>fi",
    fn_with_icon(builtin.lsp_incoming_calls, "Incoming Calls", icons.incoming),
    { desc = "Fuzzy » Incoming Calls" }
  )
  nmap(
    "<leader>fo",
    fn_with_icon(builtin.lsp_outgoing_calls, "Outgoing Calls", icons.outgoing),
    { desc = "Fuzzy » Outgoing Calls" }
  )
  -- `r` is already taken, and this isn't used much anyway, so `y` not.
  nmap("<leader>fy", function()
    -- Ask for grep string
    vim.ui.input({ prompt = "Ripgrep" }, function(input)
      input = input or ""
      -- Do not execute ripgrep if the given string is empty
      if input ~= "" then
        builtin.grep_string(
          BOTTOM_THEME:with({ search = input })
            :fmt_icon("Rg", "%s %s %s", icons.double_angle.right, input, icons.magnify)
        )
      end
    end)
  end, { desc = "Fuzzy » Ripgrep" })
  -- Resume the last picker wherever it was left off.
  -- That is probably one of the nicest features that wasn't available in fzf.
  -- There are so many times were I want to do the exact same, but choose a different result,
  -- with this it's even better, because it also remembers the state, so the typed filters
  -- don't need to be repeated, super underrated feature.
  -- Note: Doesn't need to specify the theme, because it resumes whatever was used, which
  -- is usually with my theme anyway, but doesn't force it to that theme.
  nmap("<leader>fa", builtin.resume, { desc = "Fuzzy » Resume" })
end

return M
