--[[
  Keymap Configuration
  
  Organization:
  - <leader>   = Space (set early for other configs)
  - <leader>f  = Find/Files (Telescope)
  - <leader>g  = Git operations
  - <leader>l  = LSP operations  
  - <leader>b  = Buffer operations
  - <leader>w  = Window operations
  - <leader>t  = Terminal/Toggle
  
  Using modern vim.keymap.set() for all mappings
--]]

-- Set leader key first (must be before any leader mappings)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Helper function for cleaner keymap definitions
local function map(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

-------------------------------------------------------------------------------
-- Window Navigation (<leader>w prefix + quick access)
-------------------------------------------------------------------------------
map("n", "<leader>h", "<C-w>h", { desc = "Move to left window" })
map("n", "<leader>j", "<C-w>j", { desc = "Move to lower window" })
map("n", "<leader>k", "<C-w>k", { desc = "Move to upper window" })
map("n", "<leader>l", "<C-w>l", { desc = "Move to right window" })

-- Window resizing
map("n", "<leader>wj", "<cmd>resize +5<cr>", { desc = "Increase window height" })
map("n", "<leader>wk", "<cmd>resize -5<cr>", { desc = "Decrease window height" })
map("n", "<leader>wh", "<cmd>vertical resize -5<cr>", { desc = "Decrease window width" })
map("n", "<leader>wl", "<cmd>vertical resize +5<cr>", { desc = "Increase window width" })

-- Also keep shift variants for quick resizing
map("n", "<leader>J", "<cmd>resize +5<cr>", { desc = "Increase window height" })
map("n", "<leader>K", "<cmd>resize -5<cr>", { desc = "Decrease window height" })
map("n", "<leader>H", "<cmd>vertical resize -5<cr>", { desc = "Decrease window width" })
map("n", "<leader>L", "<cmd>vertical resize +5<cr>", { desc = "Increase window width" })

-------------------------------------------------------------------------------
-- Buffer Navigation (<leader>b prefix)
-------------------------------------------------------------------------------
map("n", "<leader>.", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>,", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<leader>bd", "<cmd>Bdelete<cr>", { desc = "Delete buffer" })
map("n", "<leader><Esc>", "<cmd>Bdelete<cr>", { desc = "Delete buffer" })

-------------------------------------------------------------------------------
-- File Explorer & Undo Tree
-------------------------------------------------------------------------------
map("n", "<leader>n", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle file explorer" })
map("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Toggle undo tree" })

-------------------------------------------------------------------------------
-- Telescope / Find (<leader>f prefix)
-------------------------------------------------------------------------------
map("n", "<leader>ff", function()
  require("telescope.builtin").find_files(require("telescope.themes").get_dropdown({ previewer = false }))
end, { desc = "Find files" })
map("n", "<leader>f", function()
  require("telescope.builtin").find_files(require("telescope.themes").get_dropdown({ previewer = false }))
end, { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
map("n", "<leader>t", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Find help" })
map("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Recent files" })


-------------------------------------------------------------------------------
-- LSP Operations (<leader>l prefix)
-------------------------------------------------------------------------------
map("n", "<leader>md", "<cmd>Telescope lsp_definitions<cr>", { desc = "Go to definition" })
map("n", "<leader>mD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
map("n", "<leader>mi", vim.lsp.buf.hover, { desc = "Hover documentation" })
map("n", "<leader>mrr", vim.lsp.buf.references, { desc = "Find references" })
map("n", "<leader>ma", vim.lsp.buf.code_action, { desc = "Code actions" })
map("n", "<leader>mf", vim.diagnostic.open_float, { desc = "Floating diagnostics" })
map("n", "<leader>mrn", vim.lsp.buf.rename, { desc = "Rename symbol" })
map("n", "<leader>ml", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "<leader>mq", vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })
map("n", "<leader>ms", vim.lsp.buf.signature_help, { desc = "Signature help" })
map("n", "[d", function() vim.diagnostic.goto_prev({ border = "rounded" }) end, { desc = "Previous diagnostic" })
map("n", "]d", function() vim.diagnostic.goto_next({ border = "rounded" }) end, { desc = "Next diagnostic" })
-- Formatting (now using conform.nvim via <leader>mp)
-- Keymap defined in conform.lua

-------------------------------------------------------------------------------
-- Visual Mode Improvements
-------------------------------------------------------------------------------
-- Paste without yanking the replaced text
map("x", "<leader>p", '"_dP', { desc = "Paste without yanking" })

-- Stay in visual mode when indenting
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-------------------------------------------------------------------------------
-- Navigation Improvements
-------------------------------------------------------------------------------
-- Keep cursor centered when scrolling
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up (centered)" })
map("n", "n", "nzzzv", { desc = "Next search (centered)" })
map("n", "N", "Nzzzv", { desc = "Previous search (centered)" })

-- Join lines without moving cursor
map("n", "J", "mzJ`z", { desc = "Join lines" })

-------------------------------------------------------------------------------
-- NvimTree custom keymaps (buffer-local, set on attach)
-------------------------------------------------------------------------------
-- This function is called when NvimTree attaches to a buffer
local function nvim_tree_on_attach(bufnr)
  local api = require("nvim-tree.api")

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- Default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- Custom mappings
  vim.keymap.set("n", "A", api.tree.expand_all, opts("Expand All"))
  vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
  vim.keymap.set("n", "C", api.tree.change_root_to_node, opts("CD"))
  vim.keymap.set("n", "P", function()
    local node = api.tree.get_node_under_cursor()
    print(node.absolute_path)
  end, opts("Print Node Path"))
  vim.keymap.set("n", "Z", api.node.run.system, opts("Run System"))
end

-- Export for nvim-tree setup
_G.nvim_tree_on_attach = nvim_tree_on_attach

