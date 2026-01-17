return {
  "lukas-reineke/indent-blankline.nvim",
  enabled = false,
  main = "ibl",
  config = function()
    local config = require("ibl")

    config.setup({
      debounce = 200,
      indent = {
        char = "│",
        tab_char = "│",
        -- smart_indent_cap = true,
        
      },
      whitespace = {
        remove_blankline_trail = false,
        -- highlight = { "Whitespace", "NonText" },
      },
      scope = {
        enabled = false,
        show_start = false,
        show_end = false,
      },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "lazy",
          "lspinfo",
        },
        buftypes = { "terminal", "nofile" },
      },
    })
  end,
}
