-- rust-analyzer configuration
-- Pinned to version 2025-12-15 (0.3.2719) to avoid E0107 and E0133 false positives
-- Manually managed, not installed via Mason

return {
  cmd = { vim.fn.expand("~/.local/bin/rust-analyzer") },

  filetypes = { "rust" },

  filetypes = { "rust" },
  root_markers = { "Cargo.toml", ".git" },
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true,
        loadOutDirsFromCheck = true,
      },
      procMacro = {
        enable = true,
      },
      checkOnSave = {
        command = "clippy",
      },
      inlayHints = {
        bindingModeHints = {
          enable = false,
        },
        chainingHints = {
          enable = true,
        },
        closingBraceHints = {
          enable = true,
          minLines = 25,
        },
        closureReturnTypeHints = {
          enable = "never",
        },
        discriminantHints = {
          enable = "fieldless",
        },
        expressionAdjustmentHints = {
          enable = "never",
          hideOutsideUnsafe = false,
          hideUnsafeConstructors = false,
        },
        implicitDropHints = {
          enable = true,
        },
        lifetimeElisionHints = {
          enable = "never",
          useParameterNames = false,
        },
        maxLength = 25,
        parameterHints = {
          enable = true,
        },
        reborrowHints = {
          enable = "never",
        },
        renderColons = true,
        typeHints = {
          enable = true,
          hideClosureInitialization = false,
          hideNamedConstructor = false,
        },
      },
      diagnostics = {
        enable = true,
        disabled = { "unresolved-proc-macro", "unlinked-file", "unresolved-import" },
      },
    },
  },
}
