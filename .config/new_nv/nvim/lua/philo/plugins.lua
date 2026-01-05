--[[
  Plugin Management with lazy.nvim
  
  Optimization Strategy:
  - Lazy load everything possible via events, commands, or keys
  - Use `dependencies` to co-load related plugins
  - Inline small configs to reduce file I/O
  - Remove deprecated/redundant plugins
  
  REMOVED:
  - impatient.nvim: Deprecated, Neovim 0.9+ has native caching
  - nvim-lsp-installer: Deprecated, use mason.nvim instead
  - popup.nvim: Rarely needed, telescope handles this internally
--]]

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
  ---------------------------------------------------------------------------
  -- Core Dependencies (loaded as needed by other plugins)
  ---------------------------------------------------------------------------
  { "nvim-lua/plenary.nvim", lazy = true }, -- Lua utility functions

  ---------------------------------------------------------------------------
  -- UI Components
  ---------------------------------------------------------------------------
  { "kyazdani42/nvim-web-devicons", lazy = true }, -- Icons for various plugins

  -- File Explorer
  {
    "kyazdani42/nvim-tree.lua",
    cmd = "NvimTreeToggle",
    keys = { { "<leader>n", "<cmd>NvimTreeToggle<cr>", desc = "Toggle File Explorer" } },
    config = function()
      require("philo.nvim-tree").setup()
    end,
  },

  -- Terminal
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = { "ToggleTerm", "TermExec" },
    keys = { { "<C-\\>", desc = "Toggle Terminal" } },
    config = function()
      require("philo.toggleterm").setup()
    end,
  },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      indent = { char = "│" },
      exclude = { filetypes = { "dashboard", "help", "lazy" } },
    },
  },

  -- Undo tree visualization
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = { { "<leader>u", vim.cmd.UndotreeToggle, desc = "Toggle Undo Tree" } },
  },

  -- Dashboard/Start screen
  {
    "glepnir/dashboard-nvim",
    event = "VimEnter",
    dependencies = { "nvim-web-devicons" },
  },

  -- Color previewer
  {
    "norcalli/nvim-colorizer.lua",
    ft = { "css", "html", "javascript", "typescript", "lua" },
    config = function()
      require("philo.color").setup()
    end,
  },

  ---------------------------------------------------------------------------
  -- Git Integration
  ---------------------------------------------------------------------------
  { "tpope/vim-fugitive", cmd = { "G", "Git", "Gdiffsplit", "Gread", "Gwrite" } },

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    -- Config is in git.lua, loaded via init.lua
  },

  ---------------------------------------------------------------------------
  -- Editing Enhancements
  ---------------------------------------------------------------------------
  -- Auto-pairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("philo.autopairs").setup()
    end,
  },

  -- Commenting
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    config = function()
      require("philo.comm").setup()
    end,
  },

  -- Surround text objects
  {
    "kylechui/nvim-surround",
    version = "*",
    event = { "BufReadPost", "BufNewFile" },
    opts = {}, -- Uses default config
  },

  ---------------------------------------------------------------------------
  -- Statusline & Bufferline
  ---------------------------------------------------------------------------
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-web-devicons" },
  },

  { "akinsho/bufferline.nvim", event = "VeryLazy", dependencies = { "nvim-web-devicons" } },
  { "moll/vim-bbye", cmd = { "Bdelete", "Bwipeout" } }, -- Better buffer deletion

  ---------------------------------------------------------------------------
  -- Completion & Snippets
  ---------------------------------------------------------------------------
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    config = function()
      require("philo.cmp").setup()
    end,
    dependencies = {
      "hrsh7th/cmp-buffer",      -- Buffer completions
      "hrsh7th/cmp-path",        -- Path completions
      "hrsh7th/cmp-cmdline",     -- Command line completions
      "hrsh7th/cmp-nvim-lsp",    -- LSP completions
      "hrsh7th/cmp-nvim-lua",    -- Neovim Lua API completions
      "saadparwaiz1/cmp_luasnip", -- Snippet completions

      -- Snippet engine
      {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp",
        dependencies = { "rafamadriz/friendly-snippets" },
      },

      -- AI Completions (require auth)
      {
        "Exafunction/codeium.nvim",
        config = function()
          require("codeium").setup({})
        end,
      },
      {
        "zbirenbaum/copilot.lua",
        config = function()
          require("philo.copilot").setup()
        end,
      },
      {
        "zbirenbaum/copilot-cmp",
        config = function()
          require("copilot_cmp").setup()
        end,
      },
    },
  },

  ---------------------------------------------------------------------------
  -- Which-key (Keybinding hints)
  ---------------------------------------------------------------------------
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {},
  },

  ---------------------------------------------------------------------------
  -- Colorschemes (lazy load all except active one)
  ---------------------------------------------------------------------------
  { "dasupradyumna/midnight.nvim", priority = 1000 }, -- Active colorscheme
  { "lunarvim/darkplus.nvim", lazy = true },
  { "navarasu/onedark.nvim", lazy = true },
  { "Soares/base16.nvim", lazy = true },
  { "Mofiqul/dracula.nvim", lazy = true },

  ---------------------------------------------------------------------------
  -- Treesitter (Syntax highlighting & parsing)
  ---------------------------------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
  },

  ---------------------------------------------------------------------------
  -- LSP (Language Server Protocol)
  ---------------------------------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("philo.lsp")
    end,
  },

  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUpdate" },
    config = function()
      require("philo.lsp.mason").setup()
    end,
  },

  { "williamboman/mason-lspconfig.nvim", lazy = true },

  -- Java LSP (filetype-specific)
  { "mfussenegger/nvim-jdtls", ft = "java" },

  ---------------------------------------------------------------------------
  -- Telescope (Fuzzy finder)
  ---------------------------------------------------------------------------
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    cmd = "Telescope",
    keys = {
      { "<leader>f", desc = "Find Files" },
      { "<leader>t", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-media-files.nvim",
    },
    config = function()
      require("philo.tel").setup()
    end,
  },

  ---------------------------------------------------------------------------
  -- Formatting & Linting
  ---------------------------------------------------------------------------
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("philo.lsp.conform").setup()
    end,
  },

  ---------------------------------------------------------------------------
  -- Tracking (optional - requires API key)
  ---------------------------------------------------------------------------
  { "wakatime/vim-wakatime", event = "VeryLazy" },
}

-- Setup lazy.nvim with performance optimizations
require("lazy").setup(plugins, {
  -- Performance optimizations
  performance = {
    cache = { enabled = true },
    rtp = {
      -- Disable unused built-in plugins
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
        "rplugin",
        "man",
      },
    },
  },
  -- UI settings
  ui = {
    border = "rounded",
    icons = {
      cmd = "⌘", config = "🛠", event = "📅", ft = "📂",
      init = "⚙", keys = "🗝", plugin = "🔌", runtime = "💻",
      require = "🌙", source = "📄", start = "🚀", task = "📌",
    },
  },
  -- Enable profiling for startup analysis
  profiling = {
    loader = true,
    require = true,
  },
  checker = { enabled = false }, -- Disable auto-update checking for speed
  change_detection = { enabled = false }, -- Disable config change detection
})

