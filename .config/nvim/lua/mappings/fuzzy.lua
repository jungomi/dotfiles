local themes = require("telescope.themes")
local builtin = require("telescope.builtin")
local map_utils = require("utils.map")
local nmap = map_utils.nmap

local BOTTOM_THEME = themes.get_ivy({
  results_title = false,
  preview_title = false,
  sorting_strategy = "descending",
  -- Don't cycle from the last to first entry when reaching the end.
  scroll_strategy = "limit",
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
  nmap("<leader>fh", function()
    builtin.oldfiles(BOTTOM_THEME:prefix("History  "):title("History"))
  end, { desc = "Fuzzy » History" })
  nmap("<leader>fg", function()
    builtin.git_files(BOTTOM_THEME:prefix("Git  "):title("Git"))
  end, { desc = "Fuzzy » Git files" })
  -- Git status
  nmap("<leader>fs", function()
    builtin.git_status(BOTTOM_THEME:prefix("Git  "):title("Git Status"))
  end, { desc = "Fuzzy » Git status" })
  nmap("<leader>fb", function()
    builtin.buffers(BOTTOM_THEME:prefix("Buffers  "):title("Buffers"))
  end, { desc = "Fuzzy » Buffers" })
  nmap("<leader>ft", function()
    builtin.tags(BOTTOM_THEME:prefix("Tags  "):title("Tags"))
  end, { desc = "Fuzzy » Tags" })
  nmap("<leader>fl", function()
    builtin.current_buffer_fuzzy_find(BOTTOM_THEME:prefix("Lines  "):title("Lines"))
  end, { desc = "Fuzzy » Lines" })
  nmap("<leader>fm", function()
    builtin.marks(BOTTOM_THEME:prefix("Marks  "):title("Marks"))
  end, { desc = "Fuzzy » Marks" })
  nmap("<leader>fr", function()
    -- Ask for grep string
    vim.ui.input({ prompt = "Ripgrep" }, function(input)
      input = input or ""
      -- Do not execute ripgrep if the given string is empty
      if input ~= "" then
        builtin.grep_string(
          BOTTOM_THEME:with({ search = input }):prefix(string.format("Rg » %s 🔍 ", input)):title("Rg")
        )
      end
    end)
  end, { desc = "Fuzzy » Ripgrep" })
end

return M
