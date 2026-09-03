--[[
  Autocommands
  
  Custom events and automatic behaviors
--]]

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-------------------------------------------------------------------------------
-- Highlight on yank
-------------------------------------------------------------------------------
autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

-------------------------------------------------------------------------------
-- Resize splits on window resize
-------------------------------------------------------------------------------
autocmd("VimResized", {
  desc = "Auto-resize splits when window is resized",
  group = augroup("resize-splits", { clear = true }),
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-------------------------------------------------------------------------------
-- Close certain filetypes with 'q'
-------------------------------------------------------------------------------
autocmd("FileType", {
  desc = "Close with q",
  group = augroup("close-with-q", { clear = true }),
  pattern = { "help", "lspinfo", "man", "notify", "qf", "checkhealth" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buf = event.buf, silent = true })
  end,
})

-------------------------------------------------------------------------------
-- Go to last location when opening a buffer
-------------------------------------------------------------------------------
autocmd("BufReadPost", {
  desc = "Go to last cursor position",
  group = augroup("last-location", { clear = true }),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-------------------------------------------------------------------------------
-- Auto-create parent directories when saving file
-------------------------------------------------------------------------------
autocmd("BufWritePre", {
  desc = "Create parent directories on save",
  group = augroup("auto-create-dir", { clear = true }),
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Optional: Auto-format on save (uncomment if desired)
-- autocmd("BufWritePre", {
--   desc = "Format on save",
--   group = augroup("format-on-save", { clear = true }),
--   callback = function()
--     require("conform").format({ lsp_format = "fallback", async = false, timeout_ms = 500 })
--   end,
-- })
