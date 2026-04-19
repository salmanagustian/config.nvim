return {
  {

    "catppuccin/nvim",
    priority = 150,
    name = "catppuccin",
    config = function()
      require("catppuccin").setup({
        flavour = "auto", -- latte, frappe, macchiato, mocha
        background = { -- :h background
          light = "latte",
          dark = "mocha",
        },
        transparent_background = false, -- disables setting the background color.
        float = {
          transparent = false, -- enable transparent floating windows
          solid = false, -- use solid styling for floating windows, see |winborder|
        },
        show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
        term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
        dim_inactive = {
          enabled = false, -- dims the background color of inactive window
          shade = "dark",
          percentage = 0.15, -- percentage of the shade to apply to the inactive window
        },
        no_italic = false, -- Force no italic
        no_bold = false, -- Force no bold
        no_underline = false, -- Force no underline
        styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
          comments = { "italic" }, -- Change the style of comments
          conditionals = { "italic" },
          loops = {"italic"},
          functions = {},
          keywords = {},
          strings = {},
          variables = {},
          numbers = {},
          booleans = {"bold"},
          properties = {},
          types = {"italic"},
          operators = {},
          -- miscs = {}, -- Uncomment to turn off hard-coded styles
        },
        lsp_styles = { -- Handles the style of specific lsp hl groups (see `:h lsp-highlight`).
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
            ok = { "italic" },
          },
          underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
            ok = { "underline" },
          },
          inlay_hints = {
            background = true,
          },
        },
        color_overrides = {},
        custom_highlights = function(colors)
          return {
            CursorLineNr = { fg = colors.pink, bold = true },
          }
        end,
        default_integrations = true,
        auto_integrations = false,
        integrations = {
          blink_cmp = {
            style = "bordered",
          },
          snacks = {
            enabled = true,
            -- indent_scope_color = "pink",
          },
          barbecue = { dim_dirname = true, bold_basename = true, dim_context = false, alt_background = false },
          -- cmp = true,
          gitsigns = true,
          -- hop = true,
          illuminate = { enabled = true },
          native_lsp = { enabled = true, inlay_hints = { background = true } },
          semantic_tokens = true,
          treesitter = true,
          treesitter_context = true,
          vimwiki = true,
          which_key = true,
          dap_ui = true,
        },
      })

      -- setup must be called before loading
      -- vim.cmd.colorscheme("catppuccin")
    end,
  },
  {
    "sainnhe/gruvbox-material",
    priority = 1000,
    config = function()
      vim.g.gruvbox_material_transparent_background = 2
      -- vim.g.gruvbox_material_background = "hard"
      vim.g.gruvbox_material_foreground = "mix"
      vim.g.gruvbox_material_disable_cursorline = 1
      -- vim.g.gruvbox_material_ui_contrast = "high"
      -- vim.g.gruvbox_material_float_style = "bright"
      -- vim.g.gruvbox_material_statusline_style = "mix"
      vim.g.gruvbox_material_enable_italic = 1
      vim.g.gruvbox_material_enable_bold = 1
      vim.g.gruvbox_material_dim_inactive_windows = 1

      -- vim.g.gruvbox_material_visual = "grey background"
      -- vim.g.gruvbox_material_menu_selection_background = "red"
      -- vim.g.gruvbox_material_cursor = "red"
      -- vim.g.gruvbox_material_colors_override = { bg0 = '#16181A' } -- #0e1010
      vim.g.gruvbox_material_better_performance = 1

      vim.cmd.colorscheme("gruvbox-material")
    end,
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = { italic = true, bold = true },
        variables = { italic = false },
        sidebars = "transparent",
        floats = "transparent",
      },
      cache = true,
      plugins = {
        blink = true,
      },
      on_highlights = function(hl, colors)
        hl.BlinkCmpDoc = { link = "NormalFloat" }
        hl.BlinkCmpDocBorder = { link = "FloatBorder" }
        hl.BlinkCmpSelected = { link = "PmenuSel" }
        hl.BlinkCmpMatch = { link = "CmpItemAbbrMatch" }
        hl.BlinkCmpSource = { fg = colors.blue }
        hl.BlinkCmpKind = { fg = colors.purple }
        -- hl.Pmenu = { bg = "NONE", fg = colors.fg }
        -- hl.NormalFloat = { bg = "NONE" }
      end,
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      -- vim.cmd.colorscheme("tokyonight-moon")
    end,
  },
}
