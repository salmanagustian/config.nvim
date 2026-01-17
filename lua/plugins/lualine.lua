return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = function()
    local opts = {
      options = {
        icons_enabled = true,
        theme = "auto",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
          statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" },
          winbar = { "dashboard", "alpha", "ministarter", "snacks_dashboard" },
        },
      },
      sections = {
        lualine_a = {
          {
            "mode",
          },
        },
        lualine_b = {
          {
            'filetype',
            icon_only = true,
            padding = { right = 0, left = 1 }
          },
          {
            "filename",
            file_status = true,
            newfile_status = true,
            -- color = { fg = Snacks.util.color("Special"), gui = "BOLD" },
            padding = { left = 0, right = 1 }
          },
        },
        lualine_c = {
          { -- show macro recording
            function()
              local reg = vim.fn.reg_recording()
              if reg == "" then
                return ""
              end -- not recording
              return " recording to @" .. reg
            end,
            padding = { left = 0, right = 0 },
            -- color = function()
            --   return { fg = Snacks.util.color("Constant") }
            -- end,
          },
          { -- show dap info
            function()
              return "  " .. require("dap").status()
            end,
            cond = function()
              return package.loaded["dap"] and require("dap").status() ~= ""
            end,
            -- color = function()
            --   return { fg = Snacks.util.color("Debug") }
            -- end,
          },
          { -- show diagnostic info
            "diagnostics",
            symbols = {
              error = " ",
              warn = " ",
              info = " ",
              hint = " ",
            },
          },
        },

        lualine_x = {
          { -- Lsp server name .
            function()
              local msg = "No Active Lsp"
              local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
              local clients = vim.lsp.get_clients()
              if next(clients) == nil then
                return msg
              end
              for _, client in ipairs(clients) do
                local filetypes = client.config.filetypes
                if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                  return client.name
                end
              end
              return msg
            end,
            icon = " LSP:",
            -- color = { fg = Snacks.util.color("Conditional"), gui = "bold" },
          },
          {
            "encoding",
          },
          {
            "diff",
            symbols = {
              added = " ",
              modified = " ",
              removed = " ",
            },
            source = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed,
                }
              end
            end,
          },
          { "branch", icon = "" },
        },
        lualine_y = { "progress" },
        lualine_z = {
          "location",
        },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      extensions = { "lazy", "fzf" },
    }

    return opts
  end,
}
