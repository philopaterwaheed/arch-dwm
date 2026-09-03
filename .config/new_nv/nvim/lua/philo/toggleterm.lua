--[[
  Toggleterm Configuration
  
  Provides floating terminal with custom keymaps
  Also includes shortcuts for lazygit, python REPL, etc.
--]]

local M = {}

M.setup = function()
  local status_ok, toggleterm = pcall(require, "toggleterm")
  if not status_ok then
    return
  end

  toggleterm.setup({
    size = 20,
    open_mapping = [[<c-\>]],
    hide_numbers = true,
    shade_terminals = true,
    shading_factor = 2,
    start_in_insert = true,
    insert_mappings = true,
    persist_size = true,
    direction = "float",
    close_on_exit = true,
    shell = vim.o.shell,
    float_opts = {
      border = "curved",
      winblend = 0,
      highlights = {
        border = "Normal",
        background = "Normal",
      },
    },
  })

  -- Terminal keymaps (set when terminal opens)
  vim.api.nvim_create_autocmd("TermOpen", {
    pattern = "term://*",
    callback = function()
      local opts = { buf = 0, noremap = true, silent = true }
      vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
      vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
      vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
      vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
      vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
      vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-W>l]], opts)
    end,
  })

  -- Custom terminal instances
  local Terminal = require("toggleterm.terminal").Terminal

  -- Lazygit
  local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })
  vim.keymap.set("n", "<leader>gg", function() lazygit:toggle() end, { desc = "Lazygit" })

  -- Python REPL
  local python = Terminal:new({ cmd = "python", hidden = true })
  vim.keymap.set("n", "<leader>tp", function() python:toggle() end, { desc = "Python REPL" })

  -- Node.js REPL
  local node = Terminal:new({ cmd = "node", hidden = true })
  vim.keymap.set("n", "<leader>tn", function() node:toggle() end, { desc = "Node REPL" })
end

return M
