return {
  "mfussenegger/nvim-dap",
  dependencies = {
    -- Creates a beautiful debugger UI
    "rcarriga/nvim-dap-ui",

    -- Required dependency for nvim-dap-ui
    "nvim-neotest/nvim-nio",

    -- Auto-install debug adapters
    "jay-babu/mason-nvim-dap.nvim",

    -- Language-specific debuggers
    "leoluz/nvim-dap-go", -- Golang
    "mxsdev/nvim-dap-vscode-js", -- JS

    -- Shows variable values inline as virtual text
    "theHamsta/nvim-dap-virtual-text",
  },
  keys = {
    {
      "<leader>dw",
      function()
        local widgets = require("dap.ui.widgets")
        widgets.centered_float(widgets.scopes)
      end,
      desc = "Debug: Scope Float",
    },
    {
      "<leader>dh",
      function()
        require("dap.ui.widgets").hover()
      end,
      desc = "Debug: Hover",
    },
    {
      "<leader>Dc",
      function()
        require("dap").continue()
      end,
      desc = "Debug: Start/Continue",
    },
    {
      "<leader>Dsi",
      function()
        require("dap").step_into()
      end,
      desc = "Debug: Step Into",
    },
    {
      "<leader>DsO",
      function()
        require("dap").step_over()
      end,
      desc = "Debug: Step Over",
    },
    {
      "<leader>Dso",
      function()
        require("dap").step_out()
      end,
      desc = "Debug: Step Out",
    },
    {
      "<leader>Db",
      function()
        require("dap").toggle_breakpoint()
      end,
      desc = "Debug: Toggle Breakpoint",
    },
    {
      "<leader>DB",
      function()
        require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end,
      desc = "Debug: Set Conditional Breakpoint",
    },
    {
      "<leader>Dt",
      function()
        require("dapui").toggle()
      end,
      desc = "Debug: Toggle UI",
    },
    {
      "<leader>Dr",
      function()
        require("dap").repl.toggle()
      end,
    },
    {
      "<leader>Dl",
      function()
        require("dap").run_last()
      end,
      desc = "Debug: Run Last Configuration",
    },
    {
      "<leader>Dp",
      function()
        require("dap").pick_process()
      end,
      desc = "Debug: Pick Process to Attach",
    },
    {
      "<leader>DL",
      function()
        require("dap").set_breakpoint(
          vim.fn.input("Log point message: "),
          nil,
          vim.fn.input("Log point expression: ")
        )
      end,
      desc = "Debug: Set Logpoint",
    },
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    -- Setup Mason for auto-installing debug adapters
    require("mason-nvim-dap").setup({
      automatic_installation = true,
      handlers = {},
      ensure_installed = {
        "delve",
        "js-debug-adapter",
      },
    })

    -- Setup DAP signs for breakpoints
    vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
    vim.fn.sign_define(
      "DapBreakpointCondition",
      { text = "◆", texthl = "DapBreakpointCondition", linehl = "", numhl = "" }
    )
    vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "DapBreakpointRejected", linehl = "", numhl = "" })
    vim.fn.sign_define("DapLogPoint", { text = "◉", texthl = "DapLogPoint", linehl = "", numhl = "" })
    vim.fn.sign_define("DapStopped", { text = "→", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "" })

    -- Dap UI setup
    dapui.setup({
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.40 },
            { id = "breakpoints", size = 0.20 },
            { id = "stacks", size = 0.20 },
            { id = "watches", size = 0.20 },
          },
          size = 60,
          position = "left",
        },
        {
          elements = {
            { id = "repl", size = 0.5 },
            { id = "console", size = 0.5 },
          },
          size = 15,
          position = "bottom",
        },
      },
      icons = { expanded = "", collapsed = "", current_frame = "" },
      controls = {
        icons = {
          pause = "⏸",
          play = "▶",
          step_into = "⏎",
          step_over = "⏭",
          step_out = "⏮",
          step_back = "b",
          run_last = "▶▶",
          terminate = "⏹",
          disconnect = "⏏",
        },
      },
      floating = {
        max_height = 0.3,
        max_width = 0.4,
        border = "rounded",
        mappings = {
          close = { "q", "<Esc>" },
        },
      },
      render = {
        max_type_length = 80,
        max_value_lines = 20,
      },
    })

    -- Automatically open/close DAP UI
    dap.listeners.after.event_initialized["dapui_config"] = dapui.open
    dap.listeners.before.event_terminated["dapui_config"] = dapui.close
    dap.listeners.before.event_exited["dapui_config"] = dapui.close

    -- Setup virtual text to show variable values inline (enhanced)
    require("nvim-dap-virtual-text").setup({
      enabled = true,
      enabled_commands = true,
      highlight_changed_variables = true,
      highlight_new_as_changed = false,
      show_stop_reason = true,
      commented = false,
      virt_text_pos = "eol",
      all_frames = false,
      virt_lines = false,
      virt_text_win_col = nil,
      highlight = "VirtualTextInfo",
      prefix = " ◦ ",
      display_callback = function(variable, buf, stackframe, node, options)
        if options.virt_text_pos == "inline" then
          return " = " .. variable.value
        else
          return variable.name .. " = " .. variable.value
        end
      end,
    })

    require("dap-go").setup({
      delve = {
        -- Use Mason's delve installation with fallback to system delve
        path = function()
          local mason_delve = vim.fn.stdpath("data") .. "/mason/bin/dlv"
          if vim.fn.executable(mason_delve) == 1 then
            return mason_delve
          end
          -- Fallback to system delve
          return vim.fn.exepath("dlv") ~= "" and vim.fn.exepath("dlv") or "dlv"
        end,
      },
    })

    -- =====================================================
    -- TYPESCRIPT/JAVASCRIPT DEBUG ADAPTERS
    -- =====================================================

    -- Node.js adapter
    dap.adapters["pwa-node"] = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = {
        command = "node",
        args = {
          vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
          "${port}",
        },
      },
    }

    -- Chrome/Edge adapter
    dap.adapters["pwa-chrome"] = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = {
        command = "node",
        args = {
          vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
          "${port}",
        },
      },
    }

    -- =====================================================
    -- HELPER FUNCTIONS
    -- =====================================================

    -- Get Node executable path with better fallback logic
    local function get_node_executable()
      local cwd = vim.fn.getcwd()

      -- 1. Check .nvmrc
      local nvmrc_path = cwd .. "/.nvmrc"
      if vim.fn.filereadable(nvmrc_path) == 1 then
        local version = vim.fn.trim(vim.fn.readfile(nvmrc_path)[1])
        local nvm_node_path = vim.fn.expand("~/.nvm/versions/node/" .. version .. "/bin/node")
        if vim.fn.executable(nvm_node_path) == 1 then
          vim.notify("[DAP] Using Node from .nvmrc: " .. version, vim.log.levels.INFO)
          return nvm_node_path
        end
      end

      -- 2. Check .tool-versions (asdf)
      local tool_versions_path = cwd .. "/.tool-versions"
      if vim.fn.filereadable(tool_versions_path) == 1 then
        local content = vim.fn.readfile(tool_versions_path)
        for _, line in ipairs(content) do
          if line:match("nodejs") then
            local asdf_node = vim.fn.trim("asdf which node")
            if vim.fn.executable(asdf_node) == 1 then
              vim.notify("[DAP] Using Node from asdf", vim.log.levels.INFO)
              return asdf_node
            end
          end
        end
      end

      -- 3. Check volta
      if vim.fn.executable("volta") == 1 then
        local volta_node = vim.fn.trim(vim.fn.system("volta which node"))
        if vim.fn.executable(volta_node) == 1 then
          vim.notify("[DAP] Using Node from volta", vim.log.levels.INFO)
          return volta_node
        end
      end

      -- 4. Fallback to system node
      local system_node = vim.fn.exepath("node")
      if system_node ~= "" then
        vim.notify("[DAP] Using system Node", vim.log.levels.INFO)
        return system_node
      end

      -- 5. Last resort: just "node"
      vim.notify("[DAP] Using 'node' from PATH", vim.log.levels.WARN)
      return "node"
    end

    -- =====================================================
    -- TYPESCRIPT/JAVASCRIPT CONFIGURATIONS
    -- =====================================================

    for _, language in ipairs({ "typescript", "javascript" }) do
      dap.configurations[language] = {
        -- ================================================
        -- BASIC LAUNCH CONFIGS
        -- ================================================

        {
          name = "📄 Launch Current File",
          type = "pwa-node",
          request = "launch",
          program = "${file}",
          cwd = "${workspaceFolder}",
          sourceMaps = true,
          protocol = "inspector",
          skipFiles = { "<node_internals>/**" },
          console = "integratedTerminal",
        },

        {
          name = "📘 Debug TypeScript File (ts-node)",
          type = "pwa-node",
          request = "launch",
          runtimeExecutable = "ts-node",
          runtimeArgs = { "--esm" },
          program = "${file}",
          cwd = "${workspaceFolder}",
          sourceMaps = true,
          protocol = "inspector",
          skipFiles = { "<node_internals>/**" },
          console = "integratedTerminal",
        },

        {
          name = "📗 Debug TypeScript File (tsx)",
          type = "pwa-node",
          request = "launch",
          runtimeExecutable = "tsx",
          program = "${file}",
          cwd = "${workspaceFolder}",
          sourceMaps = true,
          skipFiles = { "<node_internals>/**" },
          console = "integratedTerminal",
        },

        -- ================================================
        -- ATTACH CONFIGS (CRITICAL FOR RUNNING SERVERS)
        -- ================================================

        {
          name = "🔌 Attach to Node Process",
          type = "pwa-node",
          request = "attach",
          processId = require("dap.utils").pick_process,
          sourceMaps = true,
          skipFiles = { "<node_internals>/**", "node_modules/**" },
          restart = true,
          console = "integratedTerminal",
        },

        {
          name = "🔌 Attach by Port (Auto-detect)",
          type = "pwa-node",
          request = "attach",
          address = "localhost",
          port = 9229,
          sourceMaps = true,
          skipFiles = { "<node_internals>/**", "node_modules/**" },
          restart = true,
          localRoot = "${workspaceFolder}",
          remoteRoot = "${workspaceFolder}",
        },

        -- ================================================
        -- SERVER/BACKEND CONFIGS
        -- ================================================

        {
          name = "🚀 Debug NestJS (Launch)",
          type = "pwa-node",
          request = "launch",
          runtimeExecutable = function()
            return get_node_executable()
          end,
          runtimeArgs = { "${workspaceFolder}/node_modules/.bin/nest", "start", "--watch" },
          program = "${workspaceFolder}/dist/src/main.js",
          cwd = "${workspaceFolder}",
          sourceMaps = true,
          skipFiles = { "<node_internals>/**", "${workspaceFolder}/node_modules/**" },
          resolveSourceMapLocations = {
            "${workspaceFolder}/**",
            "!**/node_modules/**",
          },
          console = "integratedTerminal",
          protocol = "inspector",
        },

        {
          name = "🚀 Debug NestJS (Attach to running)",
          type = "pwa-node",
          request = "attach",
          processId = require("dap.utils").pick_process,
          sourceMaps = true,
          skipFiles = { "<node_internals>/**", "${workspaceFolder}/node_modules/**" },
          resolveSourceMapLocations = {
            "${workspaceFolder}/**",
            "!**/node_modules/**",
          },
          restart = true,
          console = "integratedTerminal",
        },

        {
          name = "🔧 Debug npm script",
          type = "pwa-node",
          request = "launch",
          runtimeExecutable = get_node_executable(),
          runtimeArgs = { "${workspaceFolder}/node_modules/.bin/npm", "run" },
          args = function()
            local scripts = vim.fn.readfile("${workspaceFolder}/package.json")
            -- You'll be prompted to enter script name
            return { vim.fn.input("Script name: ") }
          end,
          cwd = "${workspaceFolder}",
          sourceMaps = true,
          skipFiles = { "<node_internals>/**" },
          console = "integratedTerminal",
        },

        {
          name = "🔄 Debug with nodemon",
          type = "pwa-node",
          request = "launch",
          runtimeExecutable = "nodemon",
          program = "${file}",
          cwd = "${workspaceFolder}",
          sourceMaps = true,
          skipFiles = { "<node_internals>/**" },
          console = "integratedTerminal",
          restart = true,
        },

        -- ================================================
        -- FRONTEND/BROWSER CONFIGS
        -- ================================================

        {
          name = "🌐 Launch Chrome",
          type = "pwa-chrome",
          request = "launch",
          url = "http://localhost:3000",
          webRoot = "${workspaceFolder}",
          sourceMaps = true,
          protocol = "inspector",
          skipFiles = { "<node_internals>/**" },
        },

        {
          name = "🌐 Launch Chrome (custom port)",
          type = "pwa-chrome",
          request = "launch",
          url = function()
            return vim.fn.input("URL (e.g., http://localhost:3000): ")
          end,
          webRoot = "${workspaceFolder}",
          sourceMaps = true,
          protocol = "inspector",
          skipFiles = { "<node_internals>/**" },
        },

        {
          name = "🌐 Attach to Chrome",
          type = "pwa-chrome",
          request = "attach",
          port = 9222,
          webRoot = "${workspaceFolder}",
          sourceMaps = true,
          protocol = "inspector",
        },

        {
          name = "⚡ Debug Next.js Dev",
          type = "pwa-node",
          request = "launch",
          runtimeExecutable = "npm",
          runtimeArgs = { "run", "dev" },
          cwd = "${workspaceFolder}",
          sourceMaps = true,
          skipFiles = { "<node_internals>/**", "node_modules/**" },
          console = "integratedTerminal",
        },

        {
          name = "⚡ Debug Vite Dev",
          type = "pwa-node",
          request = "launch",
          runtimeExecutable = "npm",
          runtimeArgs = { "run", "dev" },
          cwd = "${workspaceFolder}",
          sourceMaps = true,
          skipFiles = { "<node_internals>/**", "node_modules/**" },
          console = "integratedTerminal",
        },

        -- ================================================
        -- TESTING CONFIGS
        -- ================================================

        {
          name = "🧪 Jest: Current File",
          type = "pwa-node",
          request = "launch",
          runtimeExecutable = get_node_executable(),
          runtimeArgs = {
            "./node_modules/.bin/jest",
            "--runInBand",
            "--no-cache",
            "${fileBasenameNoExtension}",
          },
          cwd = "${workspaceFolder}",
          sourceMaps = true,
          skipFiles = { "<node_internals>/**", "node_modules/**" },
          console = "integratedTerminal",
        },

        {
          name = "🧪 Jest: All Tests",
          type = "pwa-node",
          request = "launch",
          runtimeExecutable = get_node_executable(),
          runtimeArgs = { "./node_modules/.bin/jest", "--runInBand", "--no-cache" },
          cwd = "${workspaceFolder}",
          sourceMaps = true,
          skipFiles = { "<node_internals>/**", "node_modules/**" },
          console = "integratedTerminal",
        },

        {
          name = "🧪 Vitest: Current File",
          type = "pwa-node",
          request = "launch",
          runtimeExecutable = get_node_executable(),
          runtimeArgs = { "./node_modules/.bin/vitest", "--run", "${file}" },
          cwd = "${workspaceFolder}",
          sourceMaps = true,
          skipFiles = { "<node_internals>/**", "node_modules/**" },
          console = "integratedTerminal",
        },

        {
          name = "🧪 Vitest: All Tests",
          type = "pwa-node",
          request = "launch",
          runtimeExecutable = get_node_executable(),
          runtimeArgs = { "./node_modules/.bin/vitest", "--run" },
          cwd = "${workspaceFolder}",
          sourceMaps = true,
          skipFiles = { "<node_internals>/**", "node_modules/**" },
          console = "integratedTerminal",
        },

        -- ================================================
        -- FRAMEWORK-SPECIFIC CONFIGS
        -- ================================================

        {
          name = "⚛️ React Script",
          type = "pwa-node",
          request = "launch",
          runtimeExecutable = "npm",
          runtimeArgs = { "start" },
          cwd = "${workspaceFolder}",
          sourceMaps = true,
          skipFiles = { "<node_internals>/**", "node_modules/**" },
          console = "integratedTerminal",
        },
      }
    end

    -- =====================================================
    -- LOAD PROJECT-SPECIFIC CONFIGS
    -- =====================================================
    -- Automatically load .vscode/launch.json configs
    require("dap.ext.vscode").load_launchjs(nil, {
      ["pwa-node"] = { "typescript", "javascript" },
      ["pwa-chrome"] = { "typescript", "javascript" },
    })
  end,
}
