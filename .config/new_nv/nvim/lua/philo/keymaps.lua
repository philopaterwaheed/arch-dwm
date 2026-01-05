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

-------------------------------------------------------------------------------
-- PRODUCTIVITY ENHANCEMENTS
-- Additional shortcuts for faster editing and navigation
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Quick Save & Quit
-------------------------------------------------------------------------------
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
map("n", "<leader>W", "<cmd>wa<cr>", { desc = "Save all files" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit window" })
map("n", "<leader>Q", "<cmd>qa<cr>", { desc = "Quit all" })

-------------------------------------------------------------------------------
-- Line Manipulation (Normal Mode)
-------------------------------------------------------------------------------
-- Move lines up/down (Alt+j/k)
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })

-- Duplicate line
map("n", "<leader>d", "<cmd>t.<cr>", { desc = "Duplicate line" })

-- Add blank lines without entering insert mode
map("n", "<leader>o", "o<Esc>", { desc = "Add blank line below" })
map("n", "<leader>O", "O<Esc>", { desc = "Add blank line above" })

-------------------------------------------------------------------------------
-- Line Manipulation (Visual Mode)
-------------------------------------------------------------------------------
-- Move selected lines up/down (Alt+j/k)
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

-- Duplicate selection
map("v", "<leader>d", "y'>p", { desc = "Duplicate selection" })

-------------------------------------------------------------------------------
-- Insert Mode Enhancements
-------------------------------------------------------------------------------
-- Quick escape alternatives
map("i", "jk", "<Esc>", { desc = "Exit insert mode" })
map("i", "kj", "<Esc>", { desc = "Exit insert mode" })

-- Move cursor in insert mode (Ctrl + h/j/k/l)
map("i", "<C-h>", "<Left>", { desc = "Move cursor left" })
map("i", "<C-l>", "<Right>", { desc = "Move cursor right" })
map("i", "<C-j>", "<Down>", { desc = "Move cursor down" })
map("i", "<C-k>", "<Up>", { desc = "Move cursor up" })

-- Delete word backward (Ctrl+Backspace behavior)
map("i", "<C-BS>", "<C-w>", { desc = "Delete word backward" })
map("i", "<C-Del>", "<C-o>dw", { desc = "Delete word forward" })

-- Undo break points (create undo points at punctuation)
map("i", ",", ",<C-g>u", { desc = "Undo break point" })
map("i", ".", ".<C-g>u", { desc = "Undo break point" })
map("i", ";", ";<C-g>u", { desc = "Undo break point" })

-------------------------------------------------------------------------------
-- Window Splits (Quick creation)
-------------------------------------------------------------------------------
map("n", "<leader>sv", "<cmd>vsplit<cr>", { desc = "Split vertical" })
map("n", "<leader>sh", "<cmd>split<cr>", { desc = "Split horizontal" })
map("n", "<leader>se", "<C-w>=", { desc = "Equal window sizes" })
map("n", "<leader>sx", "<cmd>close<cr>", { desc = "Close current split" })

-------------------------------------------------------------------------------
-- Buffer Management (Enhanced)
-------------------------------------------------------------------------------
-- Quick buffer switching by number (bufferline ordinal)
map("n", "<leader>1", "<cmd>BufferLineGoToBuffer 1<cr>", { desc = "Go to buffer 1" })
map("n", "<leader>2", "<cmd>BufferLineGoToBuffer 2<cr>", { desc = "Go to buffer 2" })
map("n", "<leader>3", "<cmd>BufferLineGoToBuffer 3<cr>", { desc = "Go to buffer 3" })
map("n", "<leader>4", "<cmd>BufferLineGoToBuffer 4<cr>", { desc = "Go to buffer 4" })
map("n", "<leader>5", "<cmd>BufferLineGoToBuffer 5<cr>", { desc = "Go to buffer 5" })
map("n", "<leader>6", "<cmd>BufferLineGoToBuffer 6<cr>", { desc = "Go to buffer 6" })
map("n", "<leader>7", "<cmd>BufferLineGoToBuffer 7<cr>", { desc = "Go to buffer 7" })
map("n", "<leader>8", "<cmd>BufferLineGoToBuffer 8<cr>", { desc = "Go to buffer 8" })
map("n", "<leader>9", "<cmd>BufferLineGoToBuffer 9<cr>", { desc = "Go to buffer 9" })

-- Close other buffers
map("n", "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", { desc = "Close other buffers" })
map("n", "<leader>bl", "<cmd>BufferLineCloseLeft<cr>", { desc = "Close buffers to the left" })
map("n", "<leader>br", "<cmd>BufferLineCloseRight<cr>", { desc = "Close buffers to the right" })
map("n", "<leader>bp", "<cmd>BufferLinePick<cr>", { desc = "Pick buffer" })

-------------------------------------------------------------------------------
-- Enhanced Search & Replace
-------------------------------------------------------------------------------
-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- Search and replace word under cursor
map("n", "<leader>rw", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace word under cursor" })

-- Search for visual selection
map("v", "//", [[y/\V<C-R>=escape(@",'/\')<CR><CR>]], { desc = "Search for selection" })

-------------------------------------------------------------------------------
-- Quickfix & Location List Navigation
-------------------------------------------------------------------------------
map("n", "<leader>co", "<cmd>copen<cr>", { desc = "Open quickfix list" })
map("n", "<leader>cc", "<cmd>cclose<cr>", { desc = "Close quickfix list" })
map("n", "]q", "<cmd>cnext<cr>zz", { desc = "Next quickfix item" })
map("n", "[q", "<cmd>cprev<cr>zz", { desc = "Previous quickfix item" })
map("n", "]l", "<cmd>lnext<cr>zz", { desc = "Next location item" })
map("n", "[l", "<cmd>lprev<cr>zz", { desc = "Previous location item" })

-------------------------------------------------------------------------------
-- LSP Enhancements (Additional)
-------------------------------------------------------------------------------
-- Type definition (different from definition)
map("n", "<leader>lt", vim.lsp.buf.type_definition, { desc = "Type definition" })

-- Workspace symbols search
map("n", "<leader>lw", "<cmd>Telescope lsp_workspace_symbols<cr>", { desc = "Workspace symbols" })

-- Document symbols
map("n", "<leader>lo", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Document symbols (outline)" })

-- Incoming/outgoing calls
map("n", "<leader>lci", vim.lsp.buf.incoming_calls, { desc = "Incoming calls" })
map("n", "<leader>lco", vim.lsp.buf.outgoing_calls, { desc = "Outgoing calls" })

-- Diagnostics via Telescope
map("n", "<leader>lD", "<cmd>Telescope diagnostics bufnr=0<cr>", { desc = "Buffer diagnostics" })
map("n", "<leader>lW", "<cmd>Telescope diagnostics<cr>", { desc = "Workspace diagnostics" })

-- Toggle inlay hints (Neovim 0.10+)
map("n", "<leader>lh", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Toggle inlay hints" })

-------------------------------------------------------------------------------
-- Telescope Enhancements
-------------------------------------------------------------------------------
-- Search in current buffer
map("n", "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "Fuzzy find in buffer" })

-- Git-related searches
map("n", "<leader>gf", "<cmd>Telescope git_files<cr>", { desc = "Git files" })
map("n", "<leader>gc", "<cmd>Telescope git_commits<cr>", { desc = "Git commits" })
map("n", "<leader>gb", "<cmd>Telescope git_branches<cr>", { desc = "Git branches" })
map("n", "<leader>gs", "<cmd>Telescope git_status<cr>", { desc = "Git status" })

-- Search word under cursor
map("n", "<leader>fw", "<cmd>Telescope grep_string<cr>", { desc = "Find word under cursor" })

-- Resume last search
map("n", "<leader>fR", "<cmd>Telescope resume<cr>", { desc = "Resume last search" })

-- Command history
map("n", "<leader>fc", "<cmd>Telescope command_history<cr>", { desc = "Command history" })

-- Keymaps search
map("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", { desc = "Search keymaps" })

-------------------------------------------------------------------------------
-- Text Object Enhancements (Select entire buffer)
-------------------------------------------------------------------------------
map("n", "<leader>a", "ggVG", { desc = "Select all" })
map("n", "<leader>y", "<cmd>%y+<cr>", { desc = "Yank entire file" })

-------------------------------------------------------------------------------
-- Quick Fix Common Typos & Commands
-------------------------------------------------------------------------------
vim.api.nvim_create_user_command("W", "w", {})      -- :W saves
vim.api.nvim_create_user_command("Q", "q", {})      -- :Q quits
vim.api.nvim_create_user_command("Wq", "wq", {})    -- :Wq saves and quits
vim.api.nvim_create_user_command("WQ", "wq", {})    -- :WQ saves and quits

-------------------------------------------------------------------------------
-- Treesitter Text Objects (if ts-textobjects is installed)
-------------------------------------------------------------------------------
-- These work with your treesitter setup for selecting functions, classes, etc.
-- Example: vaf = select around function, vif = select inside function

-------------------------------------------------------------------------------
-- Code Folding Shortcuts
-------------------------------------------------------------------------------
map("n", "za", "za", { desc = "Toggle fold" })
map("n", "zo", "zo", { desc = "Open fold" })
map("n", "zc", "zc", { desc = "Close fold" })
map("n", "zO", "zO", { desc = "Open fold recursively" })
map("n", "zC", "zC", { desc = "Close fold recursively" })

-------------------------------------------------------------------------------
-- Better Marks
-------------------------------------------------------------------------------
map("n", "'", "`", { desc = "Jump to mark (exact position)" })

-------------------------------------------------------------------------------
-- Source/Reload Config
-------------------------------------------------------------------------------
map("n", "<leader>xr", "<cmd>source %<cr>", { desc = "Source current file" })
map("n", "<leader>xx", "<cmd>source $MYVIMRC<cr>", { desc = "Reload config" })

-------------------------------------------------------------------------------
-- Spell Check Toggle
-------------------------------------------------------------------------------
map("n", "<leader>ts", "<cmd>set spell!<cr>", { desc = "Toggle spell check" })

