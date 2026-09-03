--[[
  Conform.nvim Configuration
  
  Provides:
  - Auto-formatting on save
  - Format on demand via <leader>mp
  - Per-filetype formatter configuration
--]]

local M = {}

M.setup = function()
  local conform_ok, conform = pcall(require, "conform")
  if not conform_ok then
    return
  end

  conform.setup({
    formatters_by_ft = {
      -- C/C++
      c = { "clang-format" },
      cpp = { "clang-format" },
      -- Rust
      rust = { "rustfmt" },
      -- Python
      python = { "black" },
      -- JavaScript/TypeScript
      javascript = { "prettier" },
      typescript = { "prettier" },
      javascriptreact = { "prettier" },
      typescriptreact = { "prettier" },
      -- Web
      html = { "prettier" },
      css = { "prettier" },
      json = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },
      -- Lua
      lua = { "stylua" },
    },
    -- Format on save (optional - uncomment to enable)
    -- format_on_save = {
    --   lsp_format = "fallback",
    --   async = false,
    --   timeout_ms = 500,
    -- },
  })

  -- Manual format keymap
  vim.keymap.set({ "n", "v" }, "<leader>mp", function()
    conform.format({
      lsp_format = "fallback",
      async = false,
      timeout_ms = 500,
    })
  end, { desc = "Format file or range" })
end

return M
