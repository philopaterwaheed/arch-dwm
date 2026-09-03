--[[
  Core Neovim Options
  
  These settings are loaded first for fastest startup.
  No plugin dependencies - pure Neovim configuration.
--]]

local opt = vim.opt

-------------------------------------------------------------------------------
-- UI Settings
-------------------------------------------------------------------------------
opt.number = true            -- Show line numbers
opt.relativenumber = true    -- Relative line numbers for easy jumping
opt.cursorline = true        -- Highlight current line
opt.signcolumn = "yes"       -- Always show sign column (prevents layout shift)
opt.wrap = false             -- Don't wrap lines
opt.termguicolors = true     -- True color support
opt.winborder = "rounded"    -- Default border for hover, signature, and other floats
opt.showmode = false         -- Don't show mode (statusline handles it)
opt.pumheight = 10           -- Popup menu height
opt.scrolloff = 8            -- Lines to keep above/below cursor
opt.sidescrolloff = 8        -- Columns to keep left/right of cursor
opt.laststatus = 3           -- Global statusline

-------------------------------------------------------------------------------
-- Editing Behavior
-------------------------------------------------------------------------------
opt.mouse = "a"              -- Enable mouse in all modes
opt.clipboard = "unnamedplus" -- Use system clipboard (xclip/wl-copy)
opt.smartcase = true         -- Smart case in search
opt.ignorecase = true        -- Ignore case in search (unless uppercase used)
opt.smartindent = true       -- Smart auto-indenting
opt.expandtab = true         -- Use spaces instead of tabs
opt.shiftwidth = 4           -- Indent width
opt.tabstop = 4              -- Tab width
opt.softtabstop = 4          -- Soft tab width

-------------------------------------------------------------------------------
-- Search
-------------------------------------------------------------------------------
opt.hlsearch = false         -- Don't highlight all search matches
opt.incsearch = true         -- Incremental search

-------------------------------------------------------------------------------
-- Window Splits
-------------------------------------------------------------------------------
opt.splitbelow = true        -- Horizontal splits go below
opt.splitright = true        -- Vertical splits go right

-------------------------------------------------------------------------------
-- Performance
-------------------------------------------------------------------------------
opt.updatetime = 250         -- Faster completion (default 4000ms)
opt.timeoutlen = 300         -- Faster which-key popup
opt.lazyredraw = false       -- Don't redraw during macros (set false for noice.nvim compatibility)

-------------------------------------------------------------------------------
-- Files & Backup
-------------------------------------------------------------------------------
opt.undofile = true          -- Persistent undo
opt.backup = false           -- No backup files
opt.writebackup = false      -- No backup while editing
opt.swapfile = false         -- No swap files

-------------------------------------------------------------------------------
-- Completion
-------------------------------------------------------------------------------
opt.completeopt = { "menu", "menuone", "noselect" } -- Better completion experience

-------------------------------------------------------------------------------
-- Netrw (disabled - using nvim-tree instead)
-------------------------------------------------------------------------------
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

