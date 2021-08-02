local fn = vim.fn

local M = {}

function M.mkdir_on_save()
  local dir = fn.expand("%:p:h")
  if fn.isdirectory(dir) == 0 then
    -- Ask if the directory should be created
    -- to avoid accidentally creating a lot of dirs
    local choice = fn.confirm(
      table.concat{
        "Directory `",
        dir,
        "` does not exist.\nDo you want to create it?",
      },
      "&Yes\n&No"
    )
    if choice == 1 then
      fn.mkdir(dir, "p")
    end
  end
end

return M
