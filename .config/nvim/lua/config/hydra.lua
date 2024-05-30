local Hydra = require("hydra")
local dap = require("dap")
local dap_utils = require("utils.dap")
local resize = require("utils.resize")
local gitsigns = require("gitsigns")

local M = {}

function M.setup()
  -- I tend to use `pink` heads, which allow other keys that are not defined
  -- within the mode to be passed through, which allows things like moving
  -- across windows while remaining in resize mode, meaning that it does not
  -- need to be called again in the next window. The downside to this would
  -- be that you have to cancel it by hitting `q` or `Esc` instead of it
  -- being automatically disabled once you switch windows for example.
  -- Overall this is my preferred way as it feels the most natural to my
  -- usage patterns.
  Hydra({
    name = "Resize",
    body = "<leader>hr",
    mode = "n",
    hint = [[
 ^ ^ ^ ^         Resize
 ^ ^ ^ ^        ‾‾‾‾‾‾‾‾
 _h_,_l_: Horizontal   _j_,_k_: Vertical
 ^ _=_ ^: Equalise
 ^
 ^ ^ ^ ^      _<Esc>_/_q_: Exit
]],
    config = {
      color = "pink",
      invoke_on_body = true,
      hint = {
        position = "bottom",
        float_opts = {
          border = "rounded",
        },
      },
      timeout = 2500,
    },
    heads = {
      { "j", resize.down },
      { "k", resize.up },
      { "l", resize.right },
      { "h", resize.left },
      { "=", "<C-w>=" },
      { "<Esc>", nil, { exit = true, nowait = true } },
      { "q", nil, { exit = true, nowait = true } },
    },
  })

  Hydra({
    name = "Git",
    body = "<leader>hg",
    mode = "n",
    hint = [[
 ^ ^                 ^ ^                Git
 ^ ^                 ^ ^               ‾‾‾‾‾
 _J_: Next hunk      _s_: Stage hunk        _d_: Toggle deleted     _b_: Blame line
 _K_: Prev hunk      _u_: Undo stage hunk   _w_: Toggle word diff   _B_: Blame line (full)
 _p_: Preview hunk
 ^
 ^ ^                 _<Enter>_: Fugitive    _<Esc>_/_q_: Exit
]],
    config = {
      color = "pink",
      invoke_on_body = true,
      hint = {
        position = "bottom",
        float_opts = {
          border = "rounded",
        },
      },
      on_enter = function()
        vim.bo.modifiable = false
        gitsigns.toggle_signs(true)
        gitsigns.toggle_linehl(true)
        gitsigns.toggle_deleted(true)
      end,
      on_exit = function()
        gitsigns.toggle_signs(false)
        gitsigns.toggle_linehl(false)
        gitsigns.toggle_deleted(false)
      end,
    },
    heads = {
      {
        "J",
        function()
          if vim.wo.diff then
            return "]c"
          end
          vim.schedule(function()
            gitsigns.next_hunk()
          end)
          return "<Ignore>"
        end,
        { expr = true },
      },
      {
        "K",
        function()
          if vim.wo.diff then
            return "[c"
          end
          vim.schedule(function()
            gitsigns.prev_hunk()
          end)
          return "<Ignore>"
        end,
        { expr = true },
      },
      { "s", gitsigns.stage_hunk },
      { "u", gitsigns.undo_stage_hunk },
      { "p", gitsigns.preview_hunk },
      { "d", gitsigns.toggle_deleted, { nowait = true } },
      { "w", gitsigns.toggle_word_diff, { nowait = true } },
      { "b", gitsigns.blame_line },
      {
        "B",
        function()
          gitsigns.blame_line({ full = true })
        end,
      },
      { "<Enter>", "<cmd>Git<CR>", { exit = true } },
      { "<Esc>", nil, { exit = true, nowait = true } },
      { "q", nil, { exit = true, nowait = true } },
    },
  })

  Hydra({
    name = "Debugger",
    body = "<leader>hd",
    mode = "n",
    hint = [[
 ^ ^                Debugger
 ^ ^               ‾‾‾‾‾‾‾‾‾‾
 _c_: Continue            _b_: Toggle breakpoint
 _h_: Run to cursor       _y_: Conditional breakpoint
 _s_: Step over           _l_: Log point
 _i_: Step into           _t_: Hit count breakpoint
 _o_: Step out        _<C-c>_: Terminate debugger
 ^
 ^ ^            _<Esc>_/_q_: Exit
]],
    config = {
      color = "pink",
      invoke_on_body = true,
      hint = {
        position = "bottom",
        float_opts = {
          border = "rounded",
        },
      },
      on_enter = function()
        vim.bo.modifiable = false
      end,
    },
    heads = {
      { "c", dap.continue, { nowait = true } },
      { "h", dap.run_to_cursor, { nowait = true } },
      { "s", dap.step_over, { nowait = true } },
      { "i", dap.step_into, { nowait = true } },
      { "o", dap.step_out, { nowait = true } },
      { "b", dap.toggle_breakpoint, { nowait = true } },
      { "y", dap_utils.set_conditional_breakpoint, { nowait = true } },
      { "l", dap_utils.set_log_point, { nowait = true } },
      { "t", dap_utils.set_hit_count_breakpoint, { nowait = true } },
      { "<C-c>", dap.terminate, { exit = true, nowait = true } },
      { "<Esc>", nil, { exit = true, nowait = true } },
      { "q", nil, { exit = true, nowait = true } },
    },
  })
end

return M
