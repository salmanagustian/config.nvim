return {
  -- =====================================================
  -- LUASNIP - Snippet engine
  -- =====================================================
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    keys = {
      -- LuaSnip keybindings
      {
        "<c-k>",
        function()
          local ls = require("luasnip")
          if ls.expand_or_jumpable() then
            ls.expand_or_jump()
          end
        end,
        mode = { "i", "s" },
        desc = "Expand or jump snippet",
      },
      {
        "<c-j>",
        function()
          local ls = require("luasnip")
          if ls.jumpable(-1) then
            ls.jump(-1)
          end
        end,
        mode = { "i", "s" },
        desc = "Jump to previous snippet node",
      },
      {
        "<c-l>",
        function()
          local ls = require("luasnip")
          if ls.choice_active() then
            ls.change_choice()
          end
        end,
        mode = { "i", "s" },
        desc = "Cycle snippet choice",
      },
    },
    opts = {
      history = true,
      delete_check_events = { "TextChanged", "InsertLeave" },
      enable_autosnippets = true,
      ext_bases = {
        "require('luasnip.extras.expand_conditions')",
        "require('luasnip.extras.select_choices')",
      },
    },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/lua/snippets" })
    end,
  },

  -- =====================================================
  -- BLINK.CMP - Modern completion engine
  -- =====================================================
  {
    "saghen/blink.cmp",
    dependencies = {
      "rafamadriz/friendly-snippets",
      "L3MON4D3/LuaSnip",
    },
    version = "*",
    config = function()
      -- =====================================================
      -- HIGHLIGHT SETUP - Transparent backgrounds
      -- =====================================================
      vim.cmd("highlight Pmenu guibg=none")
      vim.cmd("highlight PmenuExtra guibg=none")
      vim.cmd("highlight FloatBorder guibg=none")
      vim.cmd("highlight NormalFloat guibg=none")
      vim.cmd("highlight BlinkCmpMenu guibg=none")
      vim.cmd("highlight BlinkCmpMenuBorder guibg=none")
      vim.cmd("highlight BlinkCmpMenuSelection guibg=#3b4261")
      vim.cmd("highlight BlinkCmpDoc guibg=none")
      vim.cmd("highlight BlinkCmpDocBorder guibg=none")
      vim.cmd("highlight BlinkCmpSignatureHelp guibg=none")
      vim.cmd("highlight BlinkCmpSignatureHelpBorder guibg=none")
      vim.cmd("highlight BlinkCmpCmdline guibg=none")
      vim.cmd("highlight BlinkCmpCmdlineBorder guibg=none")

      -- =====================================================
      -- BLINK.CMP SETUP
      -- =====================================================
      require("blink.cmp").setup({
        -- =====================================================
        -- KEYBINDINGS
        -- =====================================================
        keymap = {
          preset = "enter",

          -- Custom keybindings
          ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
          ["<C-e>"] = { "cancel", "fallback" },
          ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
          ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
          ["<C-y>"] = { "accept", "fallback" },
          ["<C-n>"] = { "select_next", "fallback" },
          ["<C-p>"] = { "select_prev", "fallback" },
          ["<C-b>"] = { "scroll_documentation_up", "fallback" },
          ["<C-f>"] = { "scroll_documentation_down", "fallback" },
          ["<C-k>"] = { "show_signature", "fallback" },
          ["<C-j>"] = { "snippet_forward", "fallback" },
          ["<C-h>"] = { "snippet_backward", "fallback" },
        },

        -- =====================================================
        -- APPEARANCE
        -- =====================================================
        appearance = {
          use_nvim_cmp_as_default = true,
          nerd_font_variant = "normal",
          kind_icons = {
            Text = "󰉿",
            Method = "󰆧",
            Function = "󰊕",
            Constructor = "󰒓",
            Field = "󰜢",
            Variable = "󰀫",
            Class = "󰠱",
            Interface = "󰜰",
            Module = "󰏗",
            Property = "󰜢",
            Unit = "󰑭",
            Value = "󰎠",
            Enum = "󰕘",
            Keyword = "󰌋",
            Snippet = "󰅴",
            Color = "󰏘",
            File = "󰈙",
            Reference = "󰈇",
            Folder = "󰉋",
            EnumMember = "󰕘",
            Constant = "󰏿",
            Struct = "󰙅",
            Event = "󱐋",
            Operator = "󰆕",
            TypeParameter = "󰊄",
          },
        },

        -- =====================================================
        -- COMPLETION
        -- =====================================================
        completion = {
          accept = {
            auto_brackets = {
              enabled = true,
              default_brackets = { "(", ")", "[", "]", "{", "}" },
              force_allow_filetypes = { "typescript", "typescriptreact", "lua" },
              kind_brackets = {
                Function = { "(", ")" },
                Method = { "(", ")" },
              },
            },
          },

          documentation = {
            auto_show = true,
            auto_show_delay_ms = 200,
            update_delay_ms = 50,
            window = {
              border = "rounded",
              winblend = 0,
              winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,EndOfBuffer:BlinkCmpDoc",
              maxWidth = 80,
              maxHeight = 20,
              minWidth = 20,
            },
          },

          ghost_text = {
            enabled = true,
          },

          menu = {
            auto_show = true,
            border = "rounded",
            scrolloff = 4,
            scrollbar = true,
            winblend = 0,
            winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
            draw = {
              columns = {
                { "kind_icon" },
                { "label", "label_description", gap = 2 },
                { "kind", hl_group = "BlinkCmpKind" },
                { "source_name", hl_group = "BlinkCmpSource" },
              },
            },
          },
        },

        -- =====================================================
        -- SOURCES
        -- =====================================================
        sources = {
          default = { "lsp", "path", "snippets", "buffer" },

          per_filetype = {
            lua = { "lsp", "path", "snippets", "buffer" },
            typescript = { "lsp", "path", "snippets", "buffer" },
            typescriptreact = { "lsp", "path", "snippets", "buffer" },
            javascript = { "lsp", "path", "snippets", "buffer" },
            javascriptreact = { "lsp", "path", "snippets", "buffer" },
            go = { "lsp", "path", "snippets", "buffer" },
            python = { "lsp", "path", "snippets", "buffer" },
            sh = { "lsp", "path", "snippets", "buffer" },
            bash = { "lsp", "path", "snippets", "buffer" },
          },

          providers = {
            lsp = {
              name = "LSP",
              module = "blink.cmp.sources.lsp",
              -- min_keyword_length = 1,
              score_offset = 100,
              async = true,
            },

            path = {
              name = "Path",
              module = "blink.cmp.sources.path",
              min_keyword_length = 1,
              score_offset = 3,
            },

            snippets = {
              name = "Snippets",
              module = "blink.cmp.sources.snippets",
              min_keyword_length = 1,
              score_offset = 50,
            },

            buffer = {
              name = "Buffer",
              module = "blink.cmp.sources.buffer",
              min_keyword_length = 2,
              score_offset = -5,
            },
          },
        },

        -- =====================================================
        -- SIGNATURE HELP
        -- =====================================================
        signature = {
          enabled = true,
          window = {
            border = "rounded",
            winblend = 0,
            winhighlight = "Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder",
            max_width = 80,
          },
        },

        -- =====================================================
        -- CMDLINE COMPLETION
        -- =====================================================
        cmdline = {
          enabled = true,
          completion = {
            menu = {
              auto_show = true,
              border = "rounded",
              winhighlight = "Normal:BlinkCmpCmdline,FloatBorder:BlinkCmpCmdlineBorder",
            },
            documentation = {
              auto_show = false,
            },
            keymap = {
              ["<Tab>"] = { "select_next", "fallback" },
              ["<S-Tab>"] = { "select_prev", "fallback" },
              ["<C-y>"] = { "accept_and_enter", "fallback" },
              ["<C-e>"] = { "cancel", "fallback" },
            },
            ghost_text = {
              enabled = false,
            },
          },
          sources = {
            default = { "cmdline" },
            providers = {
              cmdline = {
                name = "cmdline",
                module = "blink.cmp.sources.cmdline",
                min_keyword_length = 2,
              },
            },
          },
        },

        -- =====================================================
        -- FUZZY MATCHING
        -- =====================================================
        fuzzy = {
          implementation = "lua",
          sort_fuzzy_with_frequency = true,
          use_typo_resilience = true,
          max_typos = 2,
        },
        -- =====================================================
        -- PERFORMANCE
        -- =====================================================
        debounce = 60,
        throttle = 32,
      })
    end,
  },

  -- =====================================================
  -- CUSTOM SNIPPETS (optional)
  -- =====================================================
  -- {
  --   "honza/vim-snippets",
  --   lazy = true,
  --   dependencies = { "L3MON4D3/LuaSnip" },
  -- },
}
