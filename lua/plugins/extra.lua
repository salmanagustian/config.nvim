return {
  {
    "j-hui/fidget.nvim",
  },
  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    opts = {},
  },
  {
    "fladson/vim-kitty",
    ft = "kitty",
  },
  {
    "dmmulroy/ts-error-translator.nvim",
    opts = {},
    config = function ()
      require("ts-error-translator").setup()
    end
  },
}
