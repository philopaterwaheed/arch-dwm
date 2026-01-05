--[[
  Treesitter Configuration
  
  Provides:
  - Syntax highlighting
  - Incremental selection
  - Indentation
  - Performance optimization for large files
--]]

require("nvim-treesitter.configs").setup({
  -- Core parsers to always have installed
  ensure_installed = {
    "c", "cpp", "lua", "vim", "vimdoc", "query",
    "python", "rust", "javascript", "typescript",
    "html", "css", "json", "yaml", "markdown",
  },

  -- Install parsers synchronously (only for ensure_installed)
  sync_install = false,

  -- Auto-install missing parsers when entering buffer
  auto_install = true,

  -- Highlighting
  highlight = {
    enable = true,
    -- Disable for large files (performance)
    disable = function(lang, buf)
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,
    -- Don't run vim syntax highlighting alongside treesitter
    additional_vim_regex_highlighting = false,
  },

  -- Indentation based on treesitter
  indent = {
    enable = true,
  },

  -- Incremental selection (grow/shrink selection)
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<C-space>",
      node_incremental = "<C-space>",
      scope_incremental = false,
      node_decremental = "<bs>",
    },
  },
})
