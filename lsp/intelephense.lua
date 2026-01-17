return {
  cmd = { "intelephense", "--stdio" },
  filetypes = { "php" },
  root_markers = { "composer.json", ".git" },
  init_options = {
    storagePath = vim.fn.stdpath("cache") .. "/intelephense",
  },
  intelephense = {
    environment = {
      includePaths = {
        "vendor/laravel/framework/src",
        "vendor/illuminate",
      },
    },
    files = {
      maxSize = 5000000, -- naikkan limit jika project besar
      associations = { "*.php", "*.blade.php" },
      exclude = {
        "**/node_modules/**",
        "**/.git/**",
        "**/vendor/**/tests/**",
      },
    },
    diagnostics = {
      enable = true,
      undefinedTypes = true,
      undefinedFunctions = true,
      undefinedConstants = true,
      undefinedVariables = true,
      undefinedMethods = true,
      undefinedProperties = true,
      duplicateSymbols = true,
    },
    telemetry = {
      enabled = false,
    },
  },
}
