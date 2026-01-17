return {
  "goolord/alpha-nvim",
  event = "VimEnter", -- load plugin after all configuration is set
  enabled = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },

  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    local function footer()
      local stats = require("lazy").stats()
      local datetime = os.date(" %d-%B-%Y   %H:%M:%S")
      local version = vim.version()
      local nvim_version_info = "   v" .. version.major .. "." .. version.minor .. "." .. version.patch

      return datetime .. "  󱐌 " .. stats.count .. " plugins loaded" .. nvim_version_info
    end

    local logo = {
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                     ]],
      [[       ████ ██████           █████      ██                     ]],
      [[      ███████████             █████                             ]],
      [[      █████████ ███████████████████ ███   ███████████   ]],
      [[     █████████  ███    █████████████ █████ ██████████████   ]],
      [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
      [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
      [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
      [[                                                                       ]],
      [[                                                                       ]],
    }

    dashboard.section.header.val = logo
    dashboard.section.header.opts.hl = "Special"
    -- dashboard.section.footer.opts.hl = "Cotruenditional"
    dashboard.section.buttons.val = {
      dashboard.button("f", "󰱼  Find file", ":lua require('snacks.picker').files()<CR>"),
      dashboard.button("g", "  Find word", ":lua require('snacks.picker').grep()<CR>"),
      dashboard.button("r", "  Recent", ":lua require('snacks.picker').recent()<CR>"),
      dashboard.button("l", "󰒲  Lazy", ":Lazy<CR>"),
      dashboard.button("u", "󰂖  Update plugins", ":lua require('lazy').sync()<CR>"),
      dashboard.button("q", "  Quit NVIM", ":qa<CR>"),
    }

    dashboard.section.footer.val = footer()
    dashboard.opts.opts.noautocmd = true

    alpha.setup(dashboard.opts)

    require("alpha").setup(dashboard.opts)
  end,
}
