return {
  "folke/trouble.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim", -- Optional, for Telescope integration
    "folke/todo-comments.nvim", -- For TODO/FIXME/etc. navigation
  },
  opts = {}, -- for default options, refer to the configuration section for custom setup.
  lazy = true,
  specs = {
    "folke/snacks.nvim",
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts or {}, {
        picker = {
          actions = require("trouble.sources.snacks").actions,
          win = {
            input = {
              keys = {
                ["<c-t>"] = {
                  "trouble_open",
                  mode = { "n", "i" },
                },
              },
            },
          },
        },
      })
    end,
  },
  cmd = "Trouble",
  keys = {
    -- =====================================================
    -- DIAGNOSTICS
    -- =====================================================
    {
      "<leader>xx",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "Diagnostics (Trouble)",
    },
    {
      "<leader>xb",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      desc = "Buffer Diagnostics (Trouble)",
    },
    {
      "<leader>xs",
      "<cmd>Trouble diagnostics toggle severity=vim.diagnostic.severity.ERROR<cr>",
      desc = "Errors Only (Trouble)",
    },
    {
      "<leader>xw",
      "<cmd>Trouble diagnostics toggle severity=vim.diagnostic.severity.WARN<cr>",
      desc = "Warnings Only (Trouble)",
    },
    {
      "<leader>xd",
      "<cmd>Trouble diagnostics toggle filter.buf=0 severity=vim.diagnostic.severity.ERROR<cr>",
      desc = "Buffer Errors Only (Trouble)",
    },
    {
      "<leader>xm",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "Toggle Workspace/Document (Trouble)",
      mode = { "n", "v" },
    },

    -- =====================================================
    -- TODO / FIXME / NOTE
    -- =====================================================
    {
      "<leader>xt",
      "<cmd>Trouble todo toggle<cr>",
      desc = "Todo/Fix/Fixme (Trouble)",
    },
    {
      "<leader>xT",
      "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>",
      desc = "Todo/Fix/Fixme (Trouble)",
    },
    {
      "<leader>xN",
      "<cmd>Trouble todo toggle filter={tag={NOTE}}<cr>",
      desc = "Notes (Trouble)",
    },
    {
      "<leader>xB",
      "<cmd>Trouble todo toggle filter={tag={BUG}}<cr>",
      desc = "Bugs (Trouble)",
    },

    -- =====================================================
    -- LSP REFERENCES & DEFINITIONS
    -- =====================================================
    {
      "<leader>cs",
      "<cmd>Trouble symbols toggle focus=false<cr>",
      desc = "Symbols (Trouble)",
    },
    {
      "<leader>cr",
      "<cmd>Trouble lsp_references toggle<cr>",
      desc = "LSP References (Trouble)",
    },
    {
      "<leader>cd",
      "<cmd>Trouble lsp_definitions toggle<cr>",
      desc = "LSP Definitions (Trouble)",
    },
    {
      "<leader>ci",
      "<cmd>Trouble lsp_implementations toggle<cr>",
      desc = "LSP Implementations (Trouble)",
    },
    {
      "<leader>ct",
      "<cmd>Trouble lsp_type_definitions toggle<cr>",
      desc = "LSP Type Definitions (Trouble)",
    },
    {
      "<leader>cl",
      "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
      desc = "LSP All (Trouble)",
    },

    -- =====================================================
    -- GIT
    -- =====================================================
    {
      "<leader>gX",
      "<cmd>Trouble git_conflicts toggle<cr>",
      desc = "Git Conflicts (Trouble)",
    },

    -- =====================================================
    -- QUICKFIX & LOCLIST
    -- =====================================================
    {
      "<leader>xq",
      "<cmd>Trouble qflist toggle<cr>",
      desc = "Quickfix List (Trouble)",
    },
    {
      "<leader>xl",
      "<cmd>Trouble loclist toggle<cr>",
      desc = "Location List (Trouble)",
    },

    -- =====================================================
    -- TELESCOPE INTEGRATION
    -- =====================================================
    {
      "<leader>xf",
      "<cmd>TodoTrouble<cr>",
      desc = "Todo (Trouble)",
    },
    {
      "<leader>xF",
      "<cmd>TodoTelescope<cr>",
      desc = "Todo (Telescope)",
    },
  },
  config = function()
    require("trouble").setup({
      -- =====================================================
      -- GENERAL SETTINGS
      -- =====================================================
      mode = "workspace_diagnostics", -- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
      position = "bottom", -- position of the list can be: bottom, top, left, right
      height = 15, -- height of the trouble list when position is top or bottom
      width = 50, -- width of the list when position is left or right
      padding = true, -- add padding to the trouble list
      cycle_results = true, -- cycle the list when reaching the beginning or end

      -- =====================================================
      -- APPEARANCE
      -- =====================================================
      icons = {
        -- Font icons use chars from the incoming fold icons
        indent = {
          top = "╎",
          middle = "┋",
          bottom = "╎",
          -- '┃', '│', '┆', '┋', '┊', '┎', '╎', '╏'
        },
        folder_closed = "",
        folder_open = "",
        indent_chars = {
          "╎", "│", "┆", "┊", "┋", "┏",
        },
        groups = {
          -- The diagnostic groups from nvim-lspconfig
          {
            "<icon>", -- The icon (requires nvim-web-devicons) or false
            text = "Diagnostic Errors", -- The text for the group
            fg = " DiagnosticError", -- The highlight group for the text
            icon = "  ", -- The icon for the group (requires nvim-web-devicons) or false
            icon_hl = "DiagnosticError", -- The highlight group for the icon
          },
        },
        -- Diagnostic icons
        error = " ",
        warning = " ",
        hint = " ",
        info = " ",

        -- LSP kind icons (optional, requires lspkind or similar)
        kind = {
          -- Kind icons can be added here if using lspkind.nvim
        },
      },

      -- =====================================================
      -- FOLDING
      -- =====================================================
      fold_open = "", -- icon used for open folds
      fold_closed = "", -- icon used for closed folds
      group_empty = true, -- fold empty groups
      parents = 0, -- how many parents to show in the hierarchy
      indent = true, -- indent guides

      -- =====================================================
      -- BEHAVIOR
      -- =====================================================
      auto_close = false, -- auto close when there are no results
      auto_open = false, -- auto open when there are results
      auto_jump = "", -- "preview_hash", "always_jump", or false
      auto_preview = true, -- automatically open preview when possible
      follow = true, -- follow the current item
      restore = true, -- restores the last location in the list when opening

      -- =====================================================
      -- WINDOW
      -- =====================================================
      win = {
        size = { height = 15, width = 50 },
        position = "bottom",
        padding = { 1, 1, 1, 1 },
        wo = {
          winbar = "",
          statusline = "",
        },
      },

      -- =====================================================
      -- PREVIEW
      -- =====================================================
      preview = {
        type = "split", -- "split", "float", "main"
        split = {
          position = "right", -- "left", "right", "top", "bottom"
          size = 0.4, -- size of the preview window
        },
        float = {
          size = { width = 0.9, height = 0.9 },
          border = "rounded",
          focus = false,
          zindex = 200,
        },
      },

      -- =====================================================
      -- ACTION KEYS
      -- =====================================================
      keys = {
        ["?"] = "help",
        r = "refresh",
        R = "toggle_refresh",
        q = "close",
        o = "jump_close",
        ["<esc>"] = "cancel",
        ["<cr>"] = "jump",
        ["<2-leftmouse>"] = "jump",
        ["<c-s>"] = "jump_split",
        ["<c-v>"] = "jump_vsplit",
        ["<c-t>"] = "jump_tab",
        ["<p>"] = "preview",
        ["<P>"] = "toggle_preview",
        ["<s>"] = "jump",
        ["<S>"] = "use_input", -- use input for jump
        i = "toggle_ignore",
        I = "toggle_filter",

        -- Mode toggles
        z = "close_all",
        Z = "cancel",
        ["<c-m>"] = "jump_first",
        ["<c-n>"] = "jump_last",

        -- Fold actions
        ["za"] = "fold_action.toggle",
        ["zM"] = "fold_action.close_all",
        ["zR"] = "fold_action.open_all",
        ["zr"] = "fold_action.fold_open.more",
        ["zm"] = "fold_action.fold_close.more",
        ["z1"] = "fold_action.fold_open.level1",
        ["z2"] = "fold_action.fold_open.level2",
        ["z3"] = "fold_action.fold_open.level3",
        ["z4"] = "fold_action.fold_open.level4",

        -- LSP specific
        ["g."] = "jump",
        ["g,"] = "jump_first",
        ["g;"] = "jump_last",

        -- Filter by severity
        ["[e"] = "jump_next {severity=vim.diagnostic.severity.ERROR}",
        ["]e"] = "jump_prev {severity=vim.diagnostic.severity.ERROR}",
        ["[w"] = "jump_next {severity=vim.diagnostic.severity.WARN}",
        ["]w"] = "jump_prev {severity=vim.diagnostic.severity.WARN}",
      },

      -- =====================================================
      -- MODES
      -- =====================================================
      modes = {
        -- Source: https://github.com/folke/trouble.nvim/blob/main/lua/trouble/modes.lua
        diagnostics = {
          mode = "diagnostics",
          preview = {
            type = "split",
            relative = "win",
            position = "right",
            size = 0.3,
          },
        },

        symbols = {
          mode = "lsp_document_symbols",
          icon = "",
          preview = {
            type = "split",
            relative = "win",
            position = "right",
            size = 0.3,
          },
        },

        lsp = {
          mode = "lsp",
          preview = {
            type = "split",
            relative = "win",
            position = "right",
            size = 0.3,
          },
          jump = { "o", "<cr>", "<2-leftmouse>" },
        },

        lsp_references = {
          mode = "lsp_references",
          preview = {
            type = "split",
            relative = "win",
            position = "right",
            size = 0.3,
          },
        },

        lsp_definitions = {
          mode = "lsp_definitions",
          preview = {
            type = "split",
            relative = "win",
            position = "right",
            size = 0.3,
          },
        },

        lsp_implementations = {
          mode = "lsp_implementations",
          preview = {
            type = "split",
            relative = "win",
            position = "right",
            size = 0.3,
          },
        },

        lsp_type_definitions = {
          mode = "lsp_type_definitions",
          preview = {
            type = "split",
            relative = "win",
            position = "right",
            size = 0.3,
          },
        },

        todo = {
          mode = "todo",
          icon = " ",
          preview = {
            type = "split",
            relative = "win",
            position = "right",
            size = 0.3,
          },
        },

        quickfix = {
          mode = "quickfix",
          preview = {
            type = "split",
            relative = "win",
            position = "right",
            size = 0.3,
          },
        },

        loclist = {
          mode = "loclist",
          preview = {
            type = "split",
            relative = "win",
            position = "right",
            size = 0.3,
          },
        },

        git_conflicts = {
          mode = "git_conflicts",
          icon = " ",
          preview = {
            type = "split",
            relative = "win",
            position = "right",
            size = 0.3,
          },
        },
      },

      -- =====================================================
      -- FORMATTING
      -- =====================================================
      format = {
        -- {field: string, fmt: function}
        template = "{indent: {icon} {filename}}{indent: {kind_icon} {symbol}{comment}}{indent: {pos}}{indent: [{msg}]}",
      },

      -- =====================================================
      -- SORTING
      -- =====================================================
      sort = {
        -- "line", "column", "severity", "message", "filename"
        fields = { "kind", "filename", "line" },
        -- field = { "asc", "desc" }
      },

      -- =====================================================
      -- GROUPING
      -- =====================================================
      group = true, -- group results by file

      -- =====================================================
      -- FILTERS
      -- =====================================================
      filter = {
        -- any = {}, -- filter by these
        -- not = {}, -- filter out these
        -- buf = 0, -- current buffer
        -- severity = vim.diagnostic.severity.ERROR,
        -- { severity = vim.diagnostic.severity.ERROR },
        -- function(item)
        --   return true
        -- end,
      },

      -- =====================================================
      -- PINNING
      -- =====================================================
      pin = true, -- pin pinned items at the top
      pinned = {}, -- list of pinned items

      -- =====================================================
      -- NO CONFLICT
      -- =====================================================
      no_hints = false, -- completely disable hints

      -- =====================================================
      -- MISC
      -- =====================================================
      warn_no_results = false, -- warn when no results
      open_no_results = false, -- open the trouble list even when there are no results

      -- =====================================================
      -- HIGHLIGHTS
      -- =====================================================
      -- Use default highlights
      -- You can customize by setting highlight groups:
      -- TroubleNormal, TroubleCount, TroubleSign*, TroubleText*, etc.
    })

    -- =====================================================
    -- COMMANDS
    -- =====================================================
    -- Toggle workspace/document mode
    vim.api.nvim_create_user_command("TroubleToggleMode", function()
      require("trouble").toggle({ mode = "diagnostics" })
    end, { desc = "Toggle Trouble workspace/document diagnostics" })

    -- Quick filter presets
    vim.api.nvim_create_user_command("TroubleErrors", function()
      require("trouble").toggle({
        mode = "diagnostics",
        filter = { severity = vim.diagnostic.severity.ERROR },
      })
    end, { desc = "Toggle Trouble errors only" })

    vim.api.nvim_create_user_command("TroubleWarnings", function()
      require("trouble").toggle({
        mode = "diagnostics",
        filter = { severity = vim.diagnostic.severity.WARN },
      })
    end, { desc = "Toggle Trouble warnings only" })
  end,
}
