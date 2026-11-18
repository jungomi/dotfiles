-- Register package lifecycle hooks before adding packages
local hooks = function(ev)
  local name, kind = ev.data.spec.name, ev.data.kind

  -- Update treesitter parsers on treesitter update
  if name == "nvim-treesitter" and kind == "update" then
    if not ev.data.active then
      vim.cmd.packadd("nvim-treesitter")
    end
    vim.cmd("TSUpdate")
  end

  -- Install/update mcphub CLI dependency
  if name == "mcphub.nvim" and (kind == "install" or kind == "update") then
    vim.system({ "npm", "install", "-g", "mcp-hub@latest" })
  end
end

vim.api.nvim_create_autocmd("PackChanged", { callback = hooks })

local pack = require("utils.pack")

-- Collect specs from all modules in plugins/
local dir = vim.fs.joinpath(vim.fn.stdpath("config"), "lua", "plugins")
local specs = {}
for name, type in vim.fs.dir(dir) do
  if type == "file" and name:match("%.lua$") then
    table.insert(specs, require("plugins." .. name:gsub("%.lua$", "")))
  end
end

pack.load(specs)

return {}
