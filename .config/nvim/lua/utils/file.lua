local fn = vim.fn

local M = {}

function M.mkdir_on_save()
  local path = vim.api.nvim_buf_get_name(0)
  if path:find("://") then
    -- Any file with a protocol (e.g. fugitive://) is ignored, since it's not a directory to create.
    return
  end
  local dir = fn.expand("%:p:h")
  if fn.isdirectory(dir) == 0 then
    -- Ask if the directory should be created
    -- to avoid accidentally creating a lot of dirs
    local choice = fn.confirm(
      table.concat({
        "Directory `",
        dir,
        "` does not exist.\nDo you want to create it?",
      }),
      "&Yes\n&No"
    )
    if choice == 1 then
      fn.mkdir(dir, "p")
    end
  end
end

return M
