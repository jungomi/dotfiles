local nmap = require("utils.map").nmap

local M = {
  -- Formatter with fallback to LSP formatting
  -- Makes it easy to use formatters that are not included in the language server
  -- or allows to take precedence.
  "stevearc/conform.nvim",
}

function M.config()
  require("conform").setup({
    formatters_by_ft = {
      lua = { "stylua" },
      css = { "bun_fmt" },
      -- injected means it runs the appropriate formatter for code blocks.
      markdown = { "bun_fmt", "injected" },
      html = { "bun_fmt" },
      javascript = { "bun_fmt" },
      json = { "bun_fmt" },
      jsonc = { "bun_fmt" },
      toml = { "bun_fmt" },
      typescript = { "bun_fmt" },
      typescriptreact = { "bun_fmt" },
      yaml = { "bun_fmt" },
      go = { "goimports", "gofumpt" },
      -- Even though there is a ruff-lsp that does the formatting, it always operates
      -- on the whole, whereas conform only applies the changes, which preserves marks etc.
      python = { "ruff_fix_imports", "ruff_format" },
    },
    formatters = {
      -- bun fmt is compatible with prettier, therefore a faster version.
      -- Therefore, just replace the command of the prettier config.
      bun_fmt = function()
        local prettier = vim.deepcopy(require("conform.formatters.prettier"))
        -- The command is "bun fmt", but this looks for the executable.
        -- "fmt" is the subcommand, hence it needs to be defined as an argument.
        prettier.command = "bun"
        -- A wrapper to prepend "fmt" (the subcommand) to the args.
        local function prepend_subcommand_to_args_method(fn)
          return function(...)
            return vim.list_extend({ "fmt" }, fn(...))
          end
        end
        prettier.args = prepend_subcommand_to_args_method(prettier.args)
        prettier.range_args = prepend_subcommand_to_args_method(prettier.range_args)
        return prettier
      end,
      -- This is Ruff's fix with the isort rules enforced, which results in them being sorted.
      -- It is purely used to sort the imports by default, otherwise it would rely on the
      -- project to have it configured in pyproject.toml.
      ruff_fix_imports = function()
        local ruff = vim.deepcopy(require("conform.formatters.ruff_fix"))
        table.insert(ruff.args, "--extend-select")
        table.insert(ruff.args, "I")
        return ruff
      end,
    },
  })
end

function M.keys()
  nmap("<leader>lf", function()
    require("conform").format({ lsp_fallback = true, async = true })
  end, {
    desc = "LSP » Format",
  })
end

return M
