local M = {}

-- Reload Neovim configuration without restarting
function M.reload_config()
  -- Clear module cache for config and core
  local modules_to_reload = vim.tbl_filter(function(name)
    return name:match("^core") or name:match("^config") or name:match("^lsp")
  end, vim.tbl_keys(package.loaded))

  for _, mod in ipairs(modules_to_reload) do
    package.loaded[mod] = nil
  end

  -- Reload init.lua
  dofile(vim.env.MYVIMRC)

  -- Notify user
  vim.notify("Configuration reloaded successfully!", vim.log.levels.INFO, {
    title = "Config Reload",
    icon = "󰑐",
  })
end

-- Reload plugins using lazy.nvim
function M.reload_plugins()
  local lazy = require("lazy")

  -- Sync plugins (clean, install, update)
  lazy.sync({ wait = true, show = false })

  vim.notify("Plugins reloaded!", vim.log.levels.INFO, {
    title = "Plugin Reload",
    icon = "󰚩",
  })
end

-- Full reload: config + plugins
function M.full_reload()
  M.reload_config()
  M.reload_plugins()
end

-- Reload specific module (for development)
function M.reload_module(module_name)
  if package.loaded[module_name] then
    package.loaded[module_name] = nil
    require(module_name)
    vim.notify("Reloaded module: " .. module_name, vim.log.levels.INFO, {
      title = "Module Reload",
      icon = "󰏗",
    })
  else
    vim.notify("Module not loaded: " .. module_name, vim.log.levels.WARN, {
      title = "Module Reload",
    })
  end
end

return M
