local Comment = require("Comment")
local Comment_utils = require("Comment.utils")
local ts_comment_context = require("ts_context_commentstring.internal")

local M = {}

function M.setup()
  Comment.setup({
    pre_hook = function(ctx)
      local comment_type = ctx.ctype == Comment_utils.ctype.line and "__default" or "__multiline"
      return ts_comment_context.calculate_commentstring({ key = comment_type })
    end,
  })
end

return M
