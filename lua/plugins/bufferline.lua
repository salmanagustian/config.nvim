return {
  "akinsho/bufferline.nvim",
  enabled = false,
  version = "*",
  dependencies = "nvim-tree/nvim-web-devicons",
  after = "catppuccin",
  config = function()
    vim.opt.termguicolors = true
    local mocha = require("catppuccin.palettes").get_palette("mocha")
    require("bufferline").setup({
      highlights = require("catppuccin.groups.integrations.bufferline").get({
        styles = { "italic", "bold" },
        custom = {
          all = {
            fill = { bg = "#000000" },
          },
          mocha = {
            background = { fg = mocha.text },
          },
          latte = {
            background = { fg = "#000000" },
          },
        },
      }),
      options = {
        offsets = {
          {
            filetype = "neo-tree",
            text = "File Explorer",
            highlight = "Directory",
            text_align = "left",
            separator = true,
            -- padding = 1,
          },
        },
      },
    })
  end,
}
