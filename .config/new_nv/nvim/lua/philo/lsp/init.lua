--[[
  LSP Module Entry Point
  
  Loads all LSP-related configurations:
  - mason.lua: Language server installation
  - handlers.lua: LSP client configuration
  - conform.lua: Formatting (loaded separately)
--]]

local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
  vim.notify("lspconfig not found", vim.log.levels.WARN)
  return
end

-- Load LSP configurations
require("philo.lsp.mason")   -- Server installation
require("philo.lsp.handlers") -- Server configs
