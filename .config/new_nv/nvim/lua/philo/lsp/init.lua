--[[
  LSP Module Entry Point

  nvim-lspconfig is a data-only plugin: server defaults live in lsp/*.lua
  and are picked up by vim.lsp.config(). Do not require("lspconfig"); that
  framework is deprecated (see :help lspconfig-nvim-0.11).
--]]

require("philo.lsp.handlers")
