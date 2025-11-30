local M = {}

vim.diagnostic.config({
  virtual_text = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN]  = " ",
      [vim.diagnostic.severity.INFO]  = "󰋼 ",
      [vim.diagnostic.severity.HINT]  = "󰌵 ",
    },
    texthl = {
      [vim.diagnostic.severity.ERROR] = "Error",
      [vim.diagnostic.severity.WARN]  = "Error",
      [vim.diagnostic.severity.INFO]  = "Info",
      [vim.diagnostic.severity.HINT]  = "Hint",
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN]  = "",
      [vim.diagnostic.severity.INFO]  = "",
      [vim.diagnostic.severity.HINT]  = "",
    },
  },
  update_in_insert = true,
  underline = true,
  severity_sort = true,
  float = {
    focusable = true,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover,
  { border = "rounded" }
)
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
  vim.lsp.handlers.signature_help,
  { border = "rounded" }
)

local function lsp_highlight_document(client)
  if client.server_capabilities.documentHighlight then
    vim.api.nvim_exec([[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer>   lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer>  lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end
end

local function lsp_keymaps(bufnr)
  local opts = { noremap = true, silent = true }
end

local function on_attach(client, bufnr)
  if client.name == "ts_ls" then
    client.server_capabilities.documentFormattingProvider = false
  end
  lsp_keymaps(bufnr)
  lsp_highlight_document(client)
end

local capabilities = {}
local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if status_ok then
  capabilities = cmp_nvim_lsp.default_capabilities()
end

local servers = {
  "clangd",
  "pylsp",
  "html",
  "cssls",
  "jdtls",
  "ts_ls",
  "rust_analyzer",
}

vim.lsp.config("clangd", {
  capabilities = capabilities,
  on_attach = on_attach,
  -- cmd = { "clangd", "--clang-tidy", "--background-index", "--offset-encoding=utf-8" },
})

vim.lsp.config("rust_analyzer", {
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    ["rust-analyzer"] = {
      assist = { importEnforceGranularity = true, importPrefix = "crate" },
      cargo = { allFeatures = true },
      checkOnSave = { command = "clippy" },
      inlayHints = { locationLinks = false },
      diagnostics = { enable = true, experimental = { enable = true } },
    },
  },
})

vim.lsp.config("pylsp", {
  capabilities = capabilities,
  on_attach = on_attach,
})
vim.lsp.config("ts_ls", {
  capabilities = capabilities,
  on_attach = on_attach,
})
vim.lsp.config("jdtls", {
  capabilities = capabilities,
  on_attach = on_attach,
  -- cmd = { "/path/to/jdtls" }
})
vim.lsp.config("html", {
  capabilities = capabilities,
  on_attach = on_attach,
})
vim.lsp.config("cssls", {
  capabilities = capabilities,
  on_attach = on_attach,
})

for _, srv in ipairs(servers) do
  vim.lsp.enable(srv)
end

return M
