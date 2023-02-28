local autopairs = require("nvim-autopairs")
local Rule = require("nvim-autopairs.rule")

-- Find closing brackets in order to close all open brackets from this line
-- Baesd on the snippet from the autopairs wiki
-- https://github.com/windwp/nvim-autopairs/wiki/Custom-rules#expand-multiple-pairs-on-enter-key
local function get_closing_for_line(line)
  local i = -1
  local closing_chars = ""

  while true do
    i, _ = string.find(line, "[%(%)%{%}%[%]]", i + 1)
    if i == nil then
      break
    end
    local char = string.sub(line, i, i)
    local last_closed = string.sub(closing_chars, 1, 1)

    if char == "{" then
      closing_chars = "}" .. closing_chars
    elseif char == "}" then
      if last_closed ~= "}" then
        return ""
      end
      closing_chars = string.sub(closing_chars, 2)
    elseif char == "(" then
      closing_chars = ")" .. closing_chars
    elseif char == ")" then
      if last_closed ~= ")" then
        return ""
      end
      closing_chars = string.sub(closing_chars, 2)
    elseif char == "[" then
      closing_chars = "]" .. closing_chars
    elseif char == "]" then
      if last_closed ~= "]" then
        return ""
      end
      closing_chars = string.sub(closing_chars, 2)
    end
  end

  return closing_chars
end

local M = {}

function M.setup()
  autopairs.setup({
    -- Don't go out of insert mode, i.e. keep it a single undo.
    break_undo = false,
  })

  -- Remove the default bracket rules, as I only want them on <CR>
  autopairs.remove_rule("(")
  autopairs.remove_rule("[")
  autopairs.remove_rule("{")

  autopairs.add_rules({
    -- One rule to close all open brackets when hitting <CR>, hence the `:end_wise(...)`
    Rule("[%(%{%[]", "")
      :use_regex(true)
      :replace_endpair(function(opts)
        return get_closing_for_line(opts.line)
      end)
      :end_wise(function(opts)
        -- Do not endwise if there is no closing
        return get_closing_for_line(opts.line) ~= ""
      end),
    -- "Normal" rules but only for the <CR> when they are next to each other
    -- e.g.
    -- From: {|}
    -- To: {
    --   |
    -- }
    Rule("(", ")"):only_cr(),
    Rule("[", "]"):only_cr(),
    Rule("{", "}"):only_cr(),
  })
end

return M
