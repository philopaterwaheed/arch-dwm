vim.g.mapleader = " "
local opts = { noremap = true, silent = true }
local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap
-- Normal --
-- Better window navigation
keymap("n", "<leader>h", "<C-w>h", opts)
keymap("n", "<leader>j", "<C-w>j", opts)
keymap("n", "<leader>k", "<C-w>k", opts)
keymap("n", "<leader>l", "<C-w>l", opts)
keymap("n", "<leader>.", ":bnext<CR>", opts)
keymap("n", "<leader>,", ":bprevious<CR>", opts)
keymap("n", "<leader>J", "<cmd>resize +5<cr>", opts)
keymap("n", "<leader>K", "<cmd>resize -5<cr>", opts)
keymap("n", "<leader>H", "<cmd>vertical resize -5<cr>", opts)
keymap("n", "<leader>L", "<cmd>vertical resize +5<cr>", opts)
--: keymap("n", "<leader>f", "<cmd>Telescope find_files<cr>", opts)
keymap("n", "<leader>f", "<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ previewer = false }))<cr>", opts)
keymap("n", "<leader>t", "<cmd>Telescope live_grep<cr>", opts)
-- Toggle nvim-treevim
keymap('n', "<leader>n", ':NvimTreeToggle<CR>', {noremap = true, silent = true})
--
-- undo tree 
vim.keymap.set('n', "<leader>u", vim.cmd.UndotreeToggle)
-- Close tab key mapping in bufferline
keymap('n', '<leader><Esc>', ':bd<CR>', { noremap = true, silent = true })
-- telescope functions
keymap( "n", "gd", ":Telescope lsp_definitions<cr>", opts)
keymap( "n", "gD", ":lua vim.lsp.buf.declaration()<cr>", opts)
keymap( "n", "gi", ":lua  vim.lsp.buf.implementation()<cr>", opts)
-- This function has been generated from your
--   view.mappings.list
--   view.mappings.custom_only
--   remove_keymaps
--
-- You should add this function to your configuration and set on_attach = on_attach in the nvim-tree setup call.
--
-- Although care was taken to ensure correctness and completeness, your review is required.
--
-- Please check for the following issues in auto generated content:
--   "Mappings removed" is as you expect
--   "Mappings migrated" are correct
--
-- Please see https://github.com/nvim-tree/nvim-tree.lua/wiki/Migrating-To-on_attach for assistance in migrating.
--

local function on_attach(bufnr)
  local api = require('nvim-tree.api')

  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end


  -- Mappings migrated from view.mappings.list
  --
  -- You will need to insert "your code goes here" for any mappings with a custom action_cb
  vim.keymap.set('n', 'A', api.tree.expand_all, opts('Expand All'))
  vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
  vim.keymap.set('n', 'C', api.tree.change_root_to_node, opts('CD'))
  vim.keymap.set('n', 'P', function()
    local node = api.tree.get_node_under_cursor()
    print(node.absolute_path)
  end, opts('Print Node Path'))

  vim.keymap.set('n', 'Z', api.node.run.system, opts('Run System'))

end
