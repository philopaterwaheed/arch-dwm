--[[
  Mason Configuration
  
  Manages installation of:
  - Language servers (LSP)
  - Formatters
  - Linters
  - DAP adapters
--]]

local M = {}

M.setup = function()
  local mason_ok, mason = pcall(require, "mason")
  if not mason_ok then
    return
  end

  local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
  if not mason_lspconfig_ok then
    return
  end

  -- Pre-install these on first launch. Any other server: :Mason or :LspInstall
  -- and it will attach automatically (no extra vim.lsp.enable() needed).
  local servers = {
    "clangd",       -- C/C++
    "pylsp",        -- Python
    "rust_analyzer", -- Rust
    "ts_ls",        -- TypeScript/JavaScript
    "dockerls",     -- Docker
    "html",         -- HTML
    "cssls",        -- CSS
  }

  mason.setup({
    ui = {
      border = "rounded",
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
      },
    },
    log_level = vim.log.levels.INFO,
    max_concurrent_installers = 4,
  })

  mason_lspconfig.setup({
    ensure_installed = servers,
    automatic_enable = true, -- vim.lsp.enable() every Mason-installed server
  })
end

return M
