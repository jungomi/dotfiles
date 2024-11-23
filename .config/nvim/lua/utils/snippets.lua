local blink_sources = require("blink.cmp.sources.lib")

local snippets = {}

function snippets.prefix_before_cursor(buf)
  buf = buf or 0
  local cursor = vim.api.nvim_win_get_cursor(buf)
  local cursor_line = cursor[1]
  local cursor_column = cursor[2]
  local line = vim.api.nvim_buf_get_lines(0, cursor_line - 1, cursor_line, false)[1]
  -- Ignore everything after the cursor
  line = string.sub(line, 1, cursor_column)
  -- Any identifier up to the cursor, need to know the exact position.
  local match_start, match_end = string.find(line, "[%w_-]+=?$")
  if match_start == nil then
    return nil
  end
  return {
    prefix = string.sub(line, match_start, match_end),
    line = cursor_line,
    column_start = match_start,
    column_end = match_end,
    buf = buf,
  }
end

function snippets.get_snippet(prefix)
  local snippet = nil
  if blink_sources.providers["snippets"] == nil then
    return snippet
  end
  blink_sources.providers["snippets"].module:get_completions({}, function(completions)
    for _, item in ipairs(completions.items) do
      if item.label == prefix then
        snippet = item
        return
      end
    end
  end)
  return snippet
end

function snippets.expand()
  local parsed_prefix = snippets.prefix_before_cursor()
  if parsed_prefix == nil then
    return
  end
  local snippet = snippets.get_snippet(parsed_prefix.prefix)
  if snippet == nil then
    return
  end
  -- Delete the prefix first as the snippet expansion will take its place.
  vim.api.nvim_buf_set_text(
    parsed_prefix.buf,
    parsed_prefix.line - 1,
    parsed_prefix.column_start - 1,
    parsed_prefix.line - 1,
    parsed_prefix.column_end,
    { "" }
  )
  vim.snippet.expand(snippet.insertText)
end

function snippets.expand_or_jump_forward()
  if vim.snippet.active({ direction = 1 }) then
    vim.schedule(function()
      vim.snippet.jump(1)
    end)
  else
    snippets.expand()
  end
end

function snippets.jump_backward()
  if vim.snippet.active({ direction = -1 }) then
    vim.schedule(function()
      vim.snippet.jump(-1)
    end)
  end
end

return snippets
