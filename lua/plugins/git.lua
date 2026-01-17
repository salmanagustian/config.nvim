return {
  -- =====================================================
  -- GIT SIGNS - Git signs in the gutter
  -- =====================================================
  {
    "lewis6991/gitsigns.nvim",
    lazy = true,
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "┃" },
          change = { text = "┃" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
          untracked = { text = "┃" },
        },
        signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
        numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
        linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
        word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
        watch_gitdir = {
          follow_files = true,
        },
        auto_attach = true,
        attach_to_untracked = true,
        current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
          delay = 1000,
          ignore_whitespace = false,
          virt_text_priority = 100,
        },
        current_line_blame_formatter = " <author>, <author_time:%Y-%m-%d> • <summary>",
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil, -- Use default
        max_file_length = 40000, -- Disable if file is longer than this (in lines)
        preview_config = {
          -- Options passed to nvim_open_win
          border = "rounded",
          style = "minimal",
          relative = "cursor",
          row = 0,
          col = 1,
        },
        trouble = false, -- Use trouble.nvim for diagnostics
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns and require("gitsigns") or nil

          if not gs then
            return
          end

          -- Navigation
          vim.keymap.set("n", "]h", function()
            if vim.wo.diff then
              return "]h"
            end
            vim.schedule(function()
              gs.next_hunk({ navigation_message = false })
            end)
            return "<Ignore>"
          end, { expr = true, buffer = bufnr, desc = "Next hunk" })

          vim.keymap.set("n", "[h", function()
            if vim.wo.diff then
              return "[h"
            end
            vim.schedule(function()
              gs.prev_hunk({ navigation_message = false })
            end)
            return "<Ignore>"
          end, { expr = true, buffer = bufnr, desc = "Prev hunk" })

          -- Actions
          vim.keymap.set("n", "<leader>ghs", gs.stage_hunk, { buffer = bufnr, desc = "Stage hunk" })
          vim.keymap.set("n", "<leader>ghr", gs.reset_hunk, { buffer = bufnr, desc = "Reset hunk" })
          vim.keymap.set("v", "<leader>ghs", function()
            gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { buffer = bufnr, desc = "Stage hunk (visual)" })
          vim.keymap.set("v", "<leader>ghr", function()
            gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { buffer = bufnr, desc = "Reset hunk (visual)" })

          -- Text objects
          vim.keymap.set({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { buffer = bufnr, desc = "Inner hunk" })
        end,
      })
    end,
    keys = {
      -- Hunk navigation
      { "]h", desc = "Next hunk" },
      { "[h", desc = "Prev hunk" },

      -- Hunk operations
      { "<leader>ghp", "<cmd>Gitsigns preview_hunk<CR>", desc = "Preview hunk" },
      { "<leader>ghb", "<cmd>Gitsigns blame_line<CR>", desc = "Blame line" },
      { "<leader>ghd", "<cmd>Gitsigns diffthis HEAD<CR>", desc = "Diff hunk (vs HEAD)" },

      -- Buffer operations
      { "<leader>ghS", "<cmd>Gitsigns stage_buffer<CR>", desc = "Stage buffer" },
      { "<leader>ghR", "<cmd>Gitsigns reset_buffer<CR>", desc = "Reset buffer" },
      { "<leader>ghu", "<cmd>Gitsigns undo_stage_hunk<CR>", desc = "Undo stage hunk" },

      -- Toggle commands
      { "<leader>ght", "<cmd>Gitsigns toggle_signs<CR>", desc = "Toggle signs" },
      { "<leader>ghn", "<cmd>Gitsigns toggle_numhl<CR>", desc = "Toggle number highlight" },
      { "<leader>ghl", "<cmd>Gitsigns toggle_linehl<CR>", desc = "Toggle line highlight" },
      { "<leader>ghw", "<cmd>Gitsigns toggle_word_diff<CR>", desc = "Toggle word diff" },
      { "<leader>ghB", "<cmd>Gitsigns toggle_current_line_blame<CR>", desc = "Toggle line blame" },
    },
  },

  -- =====================================================
  -- DIFFVIEW - Git diff viewer
  -- =====================================================
  {
    "sindrets/diffview.nvim",
    enabled = true,
    event = "VeryLazy",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory" },
    keys = {
      -- Open diffview
      { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Diffview open" },
      { "<leader>gD", "<cmd>DiffviewOpen --untracked-files=false<CR>", desc = "Diffview open (no untracked)" },
      { "<leader>gdf", "<cmd>DiffviewFileHistory<CR>", desc = "Diffview file history" },
      { "<leader>gdF", "<cmd>DiffviewFileHistory %<CR>", desc = "Diffview current file history" },

      -- Branch comparison
      { "<leader>gbr", "<cmd>DiffviewOpen origin/main...HEAD<CR>", desc = "Diff vs origin/main" },
      { "<leader>gbh", "<cmd>DiffviewOpen HEAD~1<CR>", desc = "Diff vs HEAD~1" },

      -- Diffview controls
      { "<leader>gx", "<cmd>DiffviewClose<CR>", desc = "Close diffview" },
      { "<leader>gt", "<cmd>DiffviewToggleFiles<CR>", desc = "Toggle files panel" },
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        default = { winbar_info = true },
        file_history = { winbar_info = true },
      },
    },
  },

  -- =====================================================
  -- FUGITIVE - Git commands
  -- =====================================================
  {
    "tpope/vim-fugitive",
    lazy = true,
    cmd = { "Git", "Gdiffsplit", "Gread", "Gwrite", "Gvdiffsplit", "Glog", "Gedit", "Gsplit", "Gtabedit", "Ggrep" },
    keys = {
      -- Git status
      { "<leader>gg", "<cmd>Git<CR>", desc = "Git status" },

      -- Git commit
      { "<leader>gc", "<cmd>Git commit<CR>", desc = "Git commit" },
      { "<leader>gcA", "<cmd>Git commit --amend<CR>", desc = "Git commit amend" },
      { "<leader>gca", "<cmd>Git commit --amend --no-edit<CR>", desc = "Git commit amend (no edit)" },
      { "<leader>gce", "<cmd>Git commit --allow-empty<CR>", desc = "Git commit (empty)" },

      -- Git add/write
      { "<leader>gw", "<cmd>Gwrite<CR>", desc = "Git write (stage file)" },
      { "<leader>gwa", "<cmd>Gwrite!<CR>", desc = "Git write (force)" },

      -- Git reset/read
      { "<leader>gr", "<cmd>Gread<CR>", desc = "Git read (checkout file)" },
      { "<leader>gR", "<cmd>Git checkout -- .<CR>", desc = "Reset all changes" },

      -- Git diff
      { "<leader>gdo", "<cmd>Gdiffsplit<CR>", desc = "Git diff split" },
      { "<leader>gdv", "<cmd>Gvdiffsplit<CR>", desc = "Git vertical diff split" },

      -- Git log
      { "<leader>gl", "<cmd>Glog<CR>", desc = "Git log (buffer)" },
      { "<leader>gL", "<cmd>Git log --oneline --decorate --graph<CR>", desc = "Git log (graph)" },

      -- Git edit/split
      { "<leader>ge", "<cmd>Gedit<CR>", desc = "Git edit (index)" },
      { "<leader>gs", "<cmd>Gsplit<CR>", desc = "Git split (index)" },
      { "<leader>gt", "<cmd>Gtabedit<CR>", desc = "Git tabedit (index)" },

      -- Git grep
      { "<leader>gi", "<cmd>Ggrep<CR>", desc = "Git grep" },

      -- Git operations
      { "<leader>gp", "<cmd>Git push<CR>", desc = "Git push" },
      { "<leader>gP", "<cmd>Git pull<CR>", desc = "Git pull" },
      { "<leader>gpf", "<cmd>Git push --force-with-lease<CR>", desc = "Git push (force)" },
      { "<leader>gF", "<cmd>Git fetch<CR>", desc = "Git fetch" },
      { "<leader>gfm", "<cmd>Git fetch --all --multiple<CR>", desc = "Git fetch all" },
    },
  },

  -- =====================================================
  -- LAZYGIT - Terminal Git UI
  -- =====================================================
  {
    "kdheepak/lazygit.nvim",
    lazy = true,
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>lg", "<cmd>LazyGit<CR>", desc = "Lazygit" },
      { "<leader>lG", "<cmd>LazyGitCurrentFile<CR>", desc = "Lazygit (current file)" },
    },
  },

  -- =====================================================
  -- GIT BROWSE - Open files in GitHub/GitLab/Bitbucket
  -- =====================================================
  {
    "linrongbin16/git-browse.nvim",
    lazy = true,
    enabled = false,
    cmd = { "GitBrowse", "GitBbrowse" },
    keys = {
      -- Open in browser
      { "<leader>go", "<cmd>GitBrowse<CR>", desc = "Git browse (open in browser)" },
      { "<leader>gO", "<cmd>GitBrowse! <CR>", desc = "Git browse (open repo/commit)" },

      -- Visual mode support
      { "<leader>go", ":GitBrowse<CR>", mode = "v", desc = "Git browse (selection)" },

      -- Copy to clipboard
      { "<leader>gy", "<cmd>GitBrowse --copy<CR>", desc = "Git browse (copy URL)" },
      { "<leader>gY", "<cmd>GitBrowse! --copy<CR>", desc = "Git browse (copy repo/commit URL)" },
    },
    opts = {
      -- Default host providers (auto-detects)
      -- You can also customize behavior here
    },
  },

  -- =====================================================
  -- GIT CONFLICT - Merge conflict resolution
  -- =====================================================
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    lazy = true,
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      -- Conflict navigation
      { "]x", "<cmd>GitConflictNextConflict<CR>", desc = "Next conflict" },
      { "[x", "<cmd>GitConflictPrevConflict<CR>", desc = "Prev conflict" },

      -- Conflict resolution
      { "<leader>gCt", "<cmd>GitConflictChooseTheirs<CR>", desc = "Choose theirs" },
      { "<leader>gCo", "<cmd>GitConflictChooseOurs<CR>", desc = "Choose ours" },
      { "<leader>gCb", "<cmd>GitConflictChooseBoth<CR>", desc = "Choose both" },
      { "<leader>gC0", "<cmd>GitConflictChooseNone<CR>", desc = "Choose none" },
      { "<leader>gCn", "<cmd>GitConflictChooseNone<CR>", desc = "Choose none (alternative)" },

      -- Conflict list
      { "<leader>gCl", "<cmd>GitConflictListQf<CR>", desc = "Conflict list" },

      -- Toggle conflict markers
      { "<leader>gCv", "<cmd>GitConflictToggleConflict<CR>", desc = "Toggle conflict" },
      { "<leader>gCr", "<cmd>GitConflictRefresh<CR>", desc = "Refresh conflicts" },
    },
    opts = {
      default_mappings = true, -- Disable default keybindings
      default_commands = true, -- Keep default commands
      disable_diagnostics = true, -- Disable diagnostics in conflict regions
      list_opener = "copen", -- Command to open conflicts list
      highlights = {
        incoming = "DiffAdd",
        current = "DiffChange",
      },
    },
  },

  -- =====================================================
  -- OCTO - GitHub PR/Issue management (optional)
  -- =====================================================
  {
    "pwntester/octo.nvim",
    enabled = false, -- Set to true if you use GitHub PRs heavily
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    cmd = { "Octo" },
    keys = {
      { "<leader>gpr", "<cmd>Octo pr list<CR>", desc = "List PRs" },
      { "<leader>gi", "<cmd>Octo issue list<CR>", desc = "List issues" },
    },
    opts = {
      enable_builtin = true, -- Shows a list of builtin actions
    },
  },
}
