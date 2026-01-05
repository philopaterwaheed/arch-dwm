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

-------------------------------------------------------------------------------
-- Document Highlighting (highlight references under cursor)
-------------------------------------------------------------------------------
local function lsp_highlight_document(client, bufnr)
  if client.server_capabilities.documentHighlightProvider then
    local group = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = false })
    vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
    
    vim.api.nvim_create_autocmd("CursorHold", {
      group = group,
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd("CursorMoved", {
      group = group,
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
    
    -- Clear highlights when entering visual mode
    vim.api.nvim_create_autocmd("ModeChanged", {
      group = group,
      buffer = bufnr,
      pattern = "*:[vV\x16]*",
      callback = vim.lsp.buf.clear_references,
    })
  end
end

-------------------------------------------------------------------------------
-- LSP on_attach (called when a server attaches to a buffer)
-------------------------------------------------------------------------------
local function on_attach(client, bufnr)
  -- Disable formatting for ts_ls (use prettier via conform instead)
  if client.name == "ts_ls" then
    client.server_capabilities.documentFormattingProvider = false
  end
  
  -- Enable document highlighting
  lsp_highlight_document(client, bufnr)
  
  -- Enable inlay hints if supported (Neovim 0.10+)
  if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end
end

-------------------------------------------------------------------------------
-- LSP Capabilities (enhanced by nvim-cmp)
-------------------------------------------------------------------------------
local capabilities = vim.lsp.protocol.make_client_capabilities()
local cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if cmp_ok then
  capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
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
