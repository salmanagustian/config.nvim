return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    -- Configure custom linters using Mason-managed tools
    local mason_bin_dir = vim.fn.stdpath("data") .. "/mason/bin"

    -- Customize golangcilint to ignore exit codes (golangci-lint exits with code 1-3 when issues are found)
    local golangcilint = require("lint").linters.golangcilint
    golangcilint.ignore_exitcode = true

    -- Configure Laravel Pint for linting (using --test mode)
    local pint_cmd = vim.fn.executable(mason_bin_dir .. "/pint") == 1 and mason_bin_dir .. "/pint" or "pint"

    -- Configure clippy for Rust linting
    lint.linters.clippy = {
      cmd = "cargo",
      stdin = false,
      args = { "clippy", "--message-format=json" },
      stream = "stdout",
      ignore_exitcode = true,
      parser = function(output, bufnr)
        local diagnostics = {}

        if not output or output == "" then
          return diagnostics
        end

        for _, line in ipairs(vim.fn.split(output, "\n")) do
          local decoded = vim.json.decode(line)
          if decoded and decoded.message and decoded.message.spans and #decoded.message.spans > 0 then
            local span = decoded.message.spans[1]
            local severity_map = {
              error = vim.diagnostic.severity.ERROR,
              warning = vim.diagnostic.severity.WARN,
              note = vim.diagnostic.severity.INFO,
              help = vim.diagnostic.severity.HINT,
            }
            table.insert(diagnostics, {
              lnum = span.line_start - 1,
              col = span.column_start - 1,
              end_lnum = span.line_end - 1,
              end_col = span.column_end - 1,
              severity = severity_map[decoded.message.level] or vim.diagnostic.severity.WARN,
              message = decoded.message.message,
              code = decoded.code and decoded.code.code,
              source = "clippy",
            })
          end
        end

        return diagnostics
      end,
    }

    lint.linters.pint = {
      cmd = pint_cmd,
      stdin = false,
      args = { "--test" },
      stream = "stderr", -- Pint outputs diagnostics to stderr
      ignore_exitcode = true,
      parser = function(output, bufnr)
        local diagnostics = {}

        if not output or output == "" then
          return diagnostics
        end

        -- Check if output contains style issues
        -- Pint outputs human-readable format by default when there are issues
        if string.find(output, "FAIL") or string.find(output, "differs") then
          table.insert(diagnostics, {
            lnum = 0,
            col = 0,
            message = "Code style issues found - run formatter to fix",
            severity = vim.diagnostic.severity.WARN,
            source = "pint",
          })
        end

        return diagnostics
      end,
    }

    lint.linters.biome = {
      cmd = "biome",
      stdin = false,
      args = { "lint" },
      stream = "both",
      ignore_exitcode = true,
      parser = function(output)
        local diagnostics = {}

        -- The diagnostic details we need are spread in the first 3 lines of
        -- each error report.  These variables are declared out of the FOR
        -- loop because we need to carry their values to parse multiple lines.
        local fetch_message = false
        local lnum, col, code, message

        -- When a lnum:col:code line is detected fetch_message is set to true.
        -- While fetch_message is true we will search for the error message.
        -- When a error message is detected, we will create the diagnostic and
        -- set fetch_message to false to restart the process and get the next
        -- diagnostic.
        for _, line in ipairs(vim.fn.split(output, "\n")) do
          if fetch_message then
            _, _, message = string.find(line, "%s×(.+)")

            if message then
              message = (message):gsub("^%s+×%s*", "")

              table.insert(diagnostics, {
                source = "biomejs",
                lnum = tonumber(lnum) - 1,
                col = tonumber(col),
                message = message,
                code = code,
              })

              fetch_message = false
            end
          else
            _, _, lnum, col, code = string.find(line, "[^:]+:(%d+):(%d+)%s([%a%/]+)")

            if lnum then
              fetch_message = true
            end
          end
        end

        return diagnostics
      end,
    }

    -- Configure linters by filetype (using Mason-managed tools)
    lint.linters_by_ft = {
      -- Go
      go = { "golangcilint" },

      -- JavaScript/TypeScript
      javascript = { "eslint_d" },
      typescript = { "biome", "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },

      -- Lua
      lua = { "luacheck" },

      -- Shell
      sh = { "shellcheck" },
      bash = { "shellcheck" },
      zsh = { "shellcheck" },

      -- PHP/Laravel
      php = { "pint" },

      -- Rust
      rust = { "clippy" },

      -- You can add more linters here as needed
      -- python = { "flake8", "mypy" },
    }

    -- Auto-lint on save and text changes
    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        -- Only lint if linters are available for this filetype
        local linters = lint.linters_by_ft[vim.bo.filetype]
        if linters and #linters > 0 then
          lint.try_lint()
        end
      end,
    })

    -- Manual linting command
    vim.keymap.set("n", "<leader>ll", function()
      lint.try_lint()
      vim.notify("Linting...", vim.log.levels.INFO, { title = "nvim-lint" })
    end, { desc = "Trigger linting for current file" })

    -- Show linter status
    vim.keymap.set("n", "<leader>li", function()
      local linters = lint.linters_by_ft[vim.bo.filetype] or {}
      if #linters == 0 then
        print("No linters configured for filetype: " .. vim.bo.filetype)
      else
        print("Linters for " .. vim.bo.filetype .. ": " .. table.concat(linters, ", "))

        -- Show which tools are being used
        if vim.bo.filetype == "php" then
          if string.find(pint_cmd, "mason") then
            print("Using Mason pint: " .. pint_cmd)
          else
            print("Using system pint: " .. pint_cmd)
          end
        end
      end
    end, { desc = "Show available linters for current filetype" })
  end,
}
