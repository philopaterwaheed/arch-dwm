local M = {}

-------------------------------------------------------------------------------
-- Diagnostics (see :help vim.diagnostic.config)
-------------------------------------------------------------------------------
vim.diagnostic.config({
  virtual_text = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = "󰋼 ",
      [vim.diagnostic.severity.HINT] = "󰌵 ",
    },
  },
  update_in_insert = true,
  underline = true,
  severity_sort = true,
  float = {
    focusable = true,
    style = "minimal",
    source = true,
    header = "",
    prefix = "",
  },
  jump = {
    on_jump = function(_, bufnr)
      vim.diagnostic.open_float({
        bufnr = bufnr,
        scope = "cursor",
        focus = false,
      })
    end,
  },
})

-------------------------------------------------------------------------------
-- Document Highlighting (highlight references under cursor)
-------------------------------------------------------------------------------
local function lsp_highlight_document(client, bufnr)
  if client.server_capabilities.documentHighlightProvider then
    local group = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = false })
    vim.api.nvim_clear_autocmds({ buf = bufnr, group = group })

    vim.api.nvim_create_autocmd("CursorHold", {
      group = group,
      buf = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd("CursorMoved", {
      group = group,
      buf = bufnr,
      callback = vim.lsp.buf.clear_references,
    })

    vim.api.nvim_create_autocmd("ModeChanged", {
      group = group,
      buf = bufnr,
      callback = function()
        local mode = vim.fn.mode()
        if mode:match("[vV\x16]") then
          vim.lsp.buf.clear_references()
        end
      end,
    })
  end
end

-------------------------------------------------------------------------------
-- LspAttach (Neovim 0.11+ replacement for per-server on_attach)
-- See :help lsp-attach
-------------------------------------------------------------------------------
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("philo.lsp", { clear = true }),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then
      return
    end
    local bufnr = ev.buf

    -- Disable formatting for ts_ls (use prettier via conform instead)
    if client.name == "ts_ls" then
      client.server_capabilities.documentFormattingProvider = false
    end

    lsp_highlight_document(client, bufnr)

    if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end

    -- Buffer-local only. Do not map `gr` (it blocks Neovim's gra/grn/grr)
    -- or `gi` (restore insert). K is already set by Neovim on attach.
    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buf = bufnr, silent = true, desc = desc })
    end

    local function jump(fn)
      return function()
        fn()
        vim.schedule(function()
          vim.cmd("normal! zz")
        end)
      end
    end

    map("n", "gd", jump(vim.lsp.buf.definition), "Go to definition (centered)")
    map("n", "gD", jump(vim.lsp.buf.declaration), "Go to declaration (centered)")
    map("n", "gri", jump(vim.lsp.buf.implementation), "Go to implementation (centered)")
    map("n", "<leader>mD", vim.lsp.buf.declaration, "Go to declaration")
    map("n", "<leader>mi", vim.lsp.buf.hover, "Hover documentation")
    map("n", "<leader>mrr", vim.lsp.buf.references, "Find references")
    map("n", "<leader>ma", vim.lsp.buf.code_action, "Code actions")
    map("n", "<leader>mrn", vim.lsp.buf.rename, "Rename symbol")
    map("n", "<leader>ms", vim.lsp.buf.signature_help, "Signature help")
    map("n", "<leader>lt", vim.lsp.buf.type_definition, "Type definition")
    map("n", "<leader>lci", vim.lsp.buf.incoming_calls, "Incoming calls")
    map("n", "<leader>lco", vim.lsp.buf.outgoing_calls, "Outgoing calls")
    map("n", "<leader>lh", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
    end, "Toggle inlay hints")
  end,
})

-------------------------------------------------------------------------------
-- LSP Capabilities (enhanced by nvim-cmp)
-------------------------------------------------------------------------------
local capabilities = vim.lsp.protocol.make_client_capabilities()
local cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if cmp_ok then
  capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

-- Shared defaults for every server (see :help vim.lsp.config)
vim.lsp.config("*", {
  capabilities = capabilities,
})

-- Optional per-server overrides. Anything installed via Mason is enabled
-- automatically (mason-lspconfig automatic_enable). No need to list servers here.
vim.lsp.config("rust_analyzer", {
  settings = {
    ["rust-analyzer"] = {
      assist = { importEnforceGranularity = true, importPrefix = "crate" },
      cargo = { allFeatures = true },
      check = { command = "clippy" },
      inlayHints = { locationLinks = false },
      diagnostics = { enable = true, experimental = { enable = true } },
    },
  },
})

return M
