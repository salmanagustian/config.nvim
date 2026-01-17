return {
  "nvimtools/none-ls.nvim",
  enabled = false,
  dependencies = {
    "nvimtools/none-ls-extras.nvim",
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local null_ls = require("null-ls")
    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

    null_ls.setup({
      sources = {
        require("none-ls.diagnostics.eslint_d").with({
          condition = function(utils)
            return utils.root_has_file({ ".eslintrc", ".eslintrc.json", ".eslintrc.js", ".eslintrc.cjs" })
          end,
        }),
        require("none-ls.formatting.eslint_d").with({
          condition = function(utils)
            return utils.root_has_file({ ".eslintrc", ".eslintrc.json", ".eslintrc.js", ".eslintrc.cjs" })
          end,
        }),
        require("none-ls.code_actions.eslint_d").with({
          condition = function(utils)
            return utils.root_has_file({ ".eslintrc", ".eslintrc.json", ".eslintrc.js", ".eslintrc.cjs" })
          end,
        }),

        null_ls.builtins.formatting.pint.with({
          filetypes = { "php" },
        }),
        null_ls.builtins.diagnostics.phpstan.with({
          condition = function(utils)
            return utils.root_has_file({ "artisan", "composer.json" })
          end,
          to_stdin = false,
          extra_args = {
            "analyse",
            "--error-format=raw",
            "$FILENAME",
          },
        }),

        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.biome.with({
          filetypes = { "typescript", "javascript" },
        }),
        null_ls.builtins.diagnostics.biome,
        -- null_ls.builtins.formatting.prettier,
      },
      on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({
                bufnr = bufnr,
                async = false,
                filter = function(current_client)
                  -- Only let null-ls deal with formatting - disable any
                  -- other LSPs from formatting.
                  return current_client.name == "null-ls"
                end,
              })
            end,
          })
        end
      end,
    })
  end,
}
