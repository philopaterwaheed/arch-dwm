local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
  return
end

require "philo.lsp.mason"
require("philo.lsp.handlers").setup()
require "philo.lsp.null-ls"
