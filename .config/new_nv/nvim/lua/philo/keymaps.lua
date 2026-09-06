--[[
  Always-on keymaps (no plugin required).

  Plugin maps live on lazy `keys` / LspAttach / plugin on_attach:
  - <leader>f / Telescope LSP pickers → telescope.nvim
  - <leader>n, <leader>u, <leader>cc, <leader>xf, bufferline, Bdelete
  - gd / gD / <leader>m* LSP (except diagnostics) → LspAttach
  - <leader>gh… / ]c [c → gitsigns on_attach
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
-- Window Navigation (<leader>w prefix)
-------------------------------------------------------------------------------
map("n", "<leader>wh", "<C-w>h", { desc = "Move to left window" })
map("n", "<leader>wj", "<C-w>j", { desc = "Move to lower window" })
map("n", "<leader>wk", "<C-w>k", { desc = "Move to upper window" })
map("n", "<leader>wl", "<C-w>l", { desc = "Move to right window" })

-- Window resizing (using arrow keys to avoid conflicts)
map("n", "<leader>w<Up>", "<cmd>resize +5<cr>", { desc = "Increase window height" })
map("n", "<leader>w<Down>", "<cmd>resize -5<cr>", { desc = "Decrease window height" })
map("n", "<leader>w<Left>", "<cmd>vertical resize -5<cr>", { desc = "Decrease window width" })
map("n", "<leader>w<Right>", "<cmd>vertical resize +5<cr>", { desc = "Increase window width" })
map("n", "<leader>w+", "<cmd>resize +5<cr>", { desc = "Increase window height" })
map("n", "<leader>w-", "<cmd>resize -5<cr>", { desc = "Decrease window height" })

-------------------------------------------------------------------------------
-- Buffer Navigation (<leader>b prefix)
-------------------------------------------------------------------------------
map("n", "<leader>.", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>,", "<cmd>bprevious<cr>", { desc = "Previous buffer" })

-------------------------------------------------------------------------------
-- Diagnostics (work without an LSP client; [d / ]d are Neovim defaults)
-------------------------------------------------------------------------------
map("n", "<leader>mf", vim.diagnostic.open_float, { desc = "Floating diagnostics" })
map("n", "<leader>ml", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "<leader>mq", vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })
map("n", "<leader>lp", function()
  vim.diagnostic.jump({ count = -vim.v.count1 })
end, { desc = "Previous diagnostic" })
map("n", "<leader>lN", function()
  vim.diagnostic.jump({ count = vim.v.count1 })
end, { desc = "Next diagnostic" })

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

-- Join lines without moving cursor (keep default J behavior enhanced)
map("n", "J", "mzJ`z", { desc = "Join lines" })
map("n", "gJ", "J", { desc = "Join lines (keep spaces)" })

-------------------------------------------------------------------------------
-- PRODUCTIVITY ENHANCEMENTS
-- Additional shortcuts for faster editing and navigation
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Quick Save & Quit
-------------------------------------------------------------------------------
map("n", "<leader>ww", "<cmd>w<cr>", { desc = "Save file" })
map("n", "<leader>W", "<cmd>wa<cr>", { desc = "Save all files" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit window" })
map("n", "<leader>Q", "<cmd>qa<cr>", { desc = "Quit all" })

-------------------------------------------------------------------------------
-- Line Manipulation (Normal Mode)
-------------------------------------------------------------------------------
-- Move lines up/down (Alt+j/k)
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })

-- Duplicate line (not <leader>d — that would delay <leader>dw)
map("n", "<leader>dl", "<cmd>t.<cr>", { desc = "Duplicate line" })

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
map("v", "<leader>dl", "y'>p", { desc = "Duplicate selection" })

-------------------------------------------------------------------------------
-- Insert Mode Enhancements
-------------------------------------------------------------------------------
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
-- Enhanced Search & Replace
-------------------------------------------------------------------------------
-- Search and replace word under cursor
map("n", "<leader>rw", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace word under cursor" })

-- Search for visual selection
map("v", "//", [[y/\V<C-R>=escape(@",'/\')<CR><CR>]], { desc = "Search for selection" })

-------------------------------------------------------------------------------
-- Quickfix & Location List Navigation
-------------------------------------------------------------------------------
map("n", "<leader>co", "<cmd>copen<cr>", { desc = "Open quickfix list" })
map("n", "<leader>cq", "<cmd>cclose<cr>", { desc = "Close quickfix list" })
map("n", "]q", "<cmd>cnext<cr>zz", { desc = "Next quickfix item" })
map("n", "[q", "<cmd>cprev<cr>zz", { desc = "Previous quickfix item" })
map("n", "]l", "<cmd>lnext<cr>zz", { desc = "Next location item" })
map("n", "[l", "<cmd>lprev<cr>zz", { desc = "Previous location item" })

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

-------------------------------------------------------------------------------
-- ADDITIONAL PRODUCTIVITY ENHANCEMENTS
-- New shortcuts for faster editing, navigation, and coding efficiency
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Smart Line Operations
-------------------------------------------------------------------------------
-- Delete line without yanking (useful when you don't want to pollute registers)
map("n", "<leader>D", '"_dd', { desc = "Delete line (no yank)" })
map("v", "<leader>D", '"_d', { desc = "Delete selection (no yank)" })

-- Yank to end of line (consistent with D and C behavior)
map("n", "Y", "y$", { desc = "Yank to end of line" })

-- Yank to system clipboard
map({ "n", "v" }, "<leader>Y", '"+y', { desc = "Yank to system clipboard" })
map("n", "<leader>yy", '"+yy', { desc = "Yank line to system clipboard" })

-- Paste from system clipboard
map({ "n", "v" }, "<leader>P", '"+p', { desc = "Paste from system clipboard" })

-------------------------------------------------------------------------------
-- Quick Text Manipulation
-------------------------------------------------------------------------------
-- Change word under cursor (like ciw but faster)
map("n", "<leader>cw", "ciw", { desc = "Change inner word" })

-- Delete word under cursor without yank
map("n", "<leader>dw", '"_diw', { desc = "Delete inner word (no yank)" })

-- Sort lines in visual mode
map("v", "<leader>ss", ":sort<cr>", { desc = "Sort selected lines" })
map("v", "<leader>su", ":sort u<cr>", { desc = "Sort unique lines" })

-- Wrap selection in quotes/brackets (works with nvim-surround but these are quick)
map("v", '<leader>"', 'c"<C-r>""<Esc>', { desc = 'Wrap in double quotes' })
map("v", "<leader>'", "c'<C-r>\"'<Esc>", { desc = "Wrap in single quotes" })
map("v", "<leader>(", "c(<C-r>\")<Esc>", { desc = "Wrap in parentheses" })
map("v", "<leader>[", "c[<C-r>\"]<Esc>", { desc = "Wrap in brackets" })
map("v", "<leader>{", "c{<C-r>\"}<Esc>", { desc = "Wrap in braces" })

-------------------------------------------------------------------------------
-- Enhanced Navigation
-------------------------------------------------------------------------------
-- Beginning/end of line (easier than 0 and $)
map({ "n", "v" }, "gh", "^", { desc = "Go to first non-blank" })
map({ "n", "v" }, "gl", "$", { desc = "Go to end of line" })

-- Quick paragraph navigation (use } and { directly or with g prefix)
map({ "n", "v" }, "g}", "}", { desc = "Next paragraph" })
map({ "n", "v" }, "g{", "{", { desc = "Previous paragraph" })

-- Center screen after G and gg
map("n", "G", "Gzz", { desc = "Go to end of file (centered)" })
map("n", "gg", "ggzz", { desc = "Go to start of file (centered)" })

-------------------------------------------------------------------------------
-- Buffer & Tab Enhancements
-------------------------------------------------------------------------------
-- Quick buffer navigation without leader
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })

-- Create new buffer
map("n", "<leader>bn", "<cmd>enew<cr>", { desc = "New buffer" })

-- Close buffer and move to previous
map("n", "<leader>bD", "<cmd>bprevious<bar>bdelete #<cr>", { desc = "Delete buffer & go prev" })

-- Tab management
map("n", "<leader><Tab>n", "<cmd>tabnew<cr>", { desc = "New tab" })
map("n", "<leader><Tab>c", "<cmd>tabclose<cr>", { desc = "Close tab" })
map("n", "<leader><Tab>l", "<cmd>tabnext<cr>", { desc = "Next tab" })
map("n", "<leader><Tab>h", "<cmd>tabprev<cr>", { desc = "Previous tab" })

-------------------------------------------------------------------------------
-- Window Management Enhancements
-------------------------------------------------------------------------------
-- Maximize/restore window (toggle)
map("n", "<leader>wm", "<C-w>|<C-w>_", { desc = "Maximize window" })
map("n", "<leader>w=", "<C-w>=", { desc = "Equalize windows" })

-- Swap windows
map("n", "<leader>wr", "<C-w>r", { desc = "Rotate windows" })
map("n", "<leader>wR", "<C-w>R", { desc = "Rotate windows (reverse)" })
map("n", "<leader>wx", "<C-w>x", { desc = "Swap with next window" })

-- Close all other windows
map("n", "<leader>wo", "<C-w>o", { desc = "Close other windows" })

-------------------------------------------------------------------------------
-- Search Enhancements
-------------------------------------------------------------------------------
-- Search current word and center
map("n", "*", "*zzzv", { desc = "Search word forward (centered)" })
map("n", "#", "#zzzv", { desc = "Search word backward (centered)" })

-- Visual mode search for selected text
map("v", "*", [[y/\V<C-R>=escape(@",'/\')<CR><CR>N]], { desc = "Search selection (stay)" })

-------------------------------------------------------------------------------
-- Improved Code Editing
-------------------------------------------------------------------------------
-- Reselect pasted text
map("n", "gp", "`[v`]", { desc = "Reselect pasted text" })

-- Select last changed/yanked text
map("n", "gV", "`[v`]", { desc = "Select last changed text" })

-------------------------------------------------------------------------------
-- Quick Toggles (<leader>T prefix)
-------------------------------------------------------------------------------
-- Toggle relative line numbers
map("n", "<leader>Tr", function()
  vim.o.relativenumber = not vim.o.relativenumber
end, { desc = "Toggle relative numbers" })

-- Toggle line numbers entirely
map("n", "<leader>Tn", function()
  vim.o.number = not vim.o.number
end, { desc = "Toggle line numbers" })

-- Toggle wrap
map("n", "<leader>Tw", "<cmd>set wrap!<cr>", { desc = "Toggle word wrap" })

-- Toggle list (show invisible chars)
map("n", "<leader>Tl", "<cmd>set list!<cr>", { desc = "Toggle list chars" })

-- Toggle cursor line
map("n", "<leader>Tc", "<cmd>set cursorline!<cr>", { desc = "Toggle cursor line" })

-- Toggle virtual edit (allow cursor beyond line end)
map("n", "<leader>Tv", function()
  if vim.o.virtualedit == "" then
    vim.o.virtualedit = "all"
    vim.notify("Virtual edit: ON")
  else
    vim.o.virtualedit = ""
    vim.notify("Virtual edit: OFF")
  end
end, { desc = "Toggle virtual edit" })

-------------------------------------------------------------------------------
-- Improved Insert Mode Shortcuts
-------------------------------------------------------------------------------
-- Quick save from insert mode
map("i", "<C-s>", "<Esc><cmd>w<cr>", { desc = "Save file" })

-- Undo from insert mode
map("i", "<C-z>", "<C-o>u", { desc = "Undo" })

-- Jump to end of line in insert mode (more ergonomic than <End>)
map("i", "<C-e>", "<End>", { desc = "Go to end of line" })
map("i", "<C-a>", "<Home>", { desc = "Go to start of line" })

-------------------------------------------------------------------------------
-- Session Management (Lightweight)
-------------------------------------------------------------------------------
-- Quick session save/load using built-in mksession
map("n", "<leader>Ss", function()
  local session_dir = vim.fn.stdpath("data") .. "/sessions/"
  vim.fn.mkdir(session_dir, "p")
  local session_file = session_dir .. vim.fn.input("Session name: ") .. ".vim"
  vim.cmd("mksession! " .. session_file)
  vim.notify("Session saved: " .. session_file)
end, { desc = "Save session" })

map("n", "<leader>Sl", function()
  local session_dir = vim.fn.stdpath("data") .. "/sessions/"
  local sessions = vim.fn.glob(session_dir .. "*.vim", false, true)
  if #sessions == 0 then
    vim.notify("No sessions found", vim.log.levels.WARN)
    return
  end
  vim.ui.select(sessions, { prompt = "Load session:" }, function(choice)
    if choice then
      vim.cmd("source " .. choice)
    end
  end)
end, { desc = "Load session" })

-------------------------------------------------------------------------------
-- Quick Fix Editing Mistakes
-------------------------------------------------------------------------------
-- Swap two characters
map("n", "<leader>xc", "xp", { desc = "Swap chars forward" })

-- Change case of word
map("n", "<leader>xu", "gUiw", { desc = "UPPERCASE word" })
map("n", "<leader>xl", "guiw", { desc = "lowercase word" })
map("n", "<leader>xt", "g~iw", { desc = "Toggle case word" })

-------------------------------------------------------------------------------
-- Navigation History
-------------------------------------------------------------------------------
-- Jump back/forward (like browser history)
map("n", "<A-Left>", "<C-o>", { desc = "Jump back" })
map("n", "<A-Right>", "<C-i>", { desc = "Jump forward" })

-- Easier access to jumplist navigation
map("n", "<leader>jo", "<C-o>", { desc = "Jump older" })
map("n", "<leader>ji", "<C-i>", { desc = "Jump newer" })

