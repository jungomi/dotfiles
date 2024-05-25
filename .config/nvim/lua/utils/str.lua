local str_utils = {}

-- Whether a string starts with one of the prefixes given in a list (table)
function str_utils.starts_with_one_of(str, prefixes)
  for _, prefix in ipairs(prefixes) do
    if vim.startswith(str, prefix) then
      return true
    end
  end
  return false
end

return str_utils
