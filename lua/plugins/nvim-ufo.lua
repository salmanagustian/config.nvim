return {
  "kevinhwang91/nvim-ufo",
  enabled = false,
  dependencies = {
    "kevinhwang91/promise-async", -- Required
    "nvim-treesitter/nvim-treesitter", -- Optional, tapi sangat disarankan
  },
  event = "BufReadPost",
  config = function()
    require("ufo").setup({
      provider_selector = function(bufnr, filetype, buftype)
        -- Gunakan LSP, kalau tidak ada fallback ke treesitter, lalu ke indent
        return { "lsp", "treesitter", "indent" }
      end,
      open_fold_hl_timeout = 400,
      close_fold_kinds = { "imports", "comment" },
      preview = {
        win_config = {
          border = { "", "─", "", "", "", "─", "", "" },
          winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
          winblend = 0,
        },
        mappings = {
          scrollU = "<C-u>",
          scrollD = "<C-d>",
          jumpTop = "[",
          jumpBot = "]",
        },
      },
    })
  end,
}
