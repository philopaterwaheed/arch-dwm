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
  { "nvim-tree/nvim-web-devicons", lazy = true }, -- Icons for various plugins

  -- File Explorer
  {
    "nvim-tree/nvim-tree.lua",
    cmd = "NvimTreeToggle",
    keys = { { "<leader>n", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file explorer" } },
    config = function()
      require("philo.nvim-tree").setup()
    end,
  },

  -- Terminal
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = { "ToggleTerm", "TermExec" },
    keys = {
      { "<C-\\>", desc = "Toggle Terminal" },
      { "<leader>gg", desc = "Lazygit" },
      { "<leader>tp", desc = "Python REPL" },
      { "<leader>tn", desc = "Node REPL" },
      {
        "<leader>xf",
        function()
          local ft = vim.bo.filetype
          local file = vim.fn.expand("%:p")
          local cmds = {
            python = "python3 " .. file,
            javascript = "node " .. file,
            typescript = "ts-node " .. file,
            lua = "lua " .. file,
            sh = "bash " .. file,
            rust = "cargo run",
            c = "gcc -o /tmp/a.out " .. file .. " && /tmp/a.out",
            cpp = "g++ -o /tmp/a.out " .. file .. " && /tmp/a.out",
          }
          local cmd = cmds[ft]
          if cmd then
            vim.cmd("TermExec cmd='" .. cmd .. "'")
          else
            vim.notify("No runner for filetype: " .. ft, vim.log.levels.WARN)
          end
        end,
        desc = "Run current file",
      },
    },
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
    keys = { { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Toggle undo tree" } },
  },

  -- Dashboard/Start screen
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  -- Color previewer
  {
    "catgoose/nvim-colorizer.lua",
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
    keys = {
      {
        "<leader>cc",
        function()
          require("Comment.api").toggle.linewise.current()
        end,
        desc = "Toggle comment line",
      },
      {
        "<leader>cc",
        "<Esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
        mode = "v",
        desc = "Toggle comment",
      },
      {
        "<C-_>",
        function()
          require("Comment.api").toggle.linewise.current()
        end,
        desc = "Toggle comment",
      },
      {
        "<C-_>",
        "<Esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
        mode = "v",
        desc = "Toggle comment",
      },
    },
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
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>1", "<cmd>BufferLineGoToBuffer 1<cr>", desc = "Go to buffer 1" },
      { "<leader>2", "<cmd>BufferLineGoToBuffer 2<cr>", desc = "Go to buffer 2" },
      { "<leader>3", "<cmd>BufferLineGoToBuffer 3<cr>", desc = "Go to buffer 3" },
      { "<leader>4", "<cmd>BufferLineGoToBuffer 4<cr>", desc = "Go to buffer 4" },
      { "<leader>5", "<cmd>BufferLineGoToBuffer 5<cr>", desc = "Go to buffer 5" },
      { "<leader>6", "<cmd>BufferLineGoToBuffer 6<cr>", desc = "Go to buffer 6" },
      { "<leader>7", "<cmd>BufferLineGoToBuffer 7<cr>", desc = "Go to buffer 7" },
      { "<leader>8", "<cmd>BufferLineGoToBuffer 8<cr>", desc = "Go to buffer 8" },
      { "<leader>9", "<cmd>BufferLineGoToBuffer 9<cr>", desc = "Go to buffer 9" },
      { "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", desc = "Close other buffers" },
      { "<leader>bl", "<cmd>BufferLineCloseLeft<cr>", desc = "Close buffers to the left" },
      { "<leader>br", "<cmd>BufferLineCloseRight<cr>", desc = "Close buffers to the right" },
      { "<leader>bp", "<cmd>BufferLinePick<cr>", desc = "Pick buffer" },
    },
  },
  {
    "moll/vim-bbye",
    cmd = { "Bdelete", "Bwipeout" },
    keys = {
      { "<leader>bd", "<cmd>Bdelete<cr>", desc = "Delete buffer" },
      { "<leader><Esc>", "<cmd>Bdelete<cr>", desc = "Delete buffer" },
    },
  },

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
          -- copilot-cmp still uses client.is_stopped(); Neovim 0.12 wants client:is_stopped()
          local source = require("copilot_cmp.source")
          function source.is_available(self)
            if self.client:is_stopped() or self.client.name ~= "copilot" then
              return false
            end
            local clients = vim.lsp.get_clients({
              bufnr = vim.api.nvim_get_current_buf(),
              id = self.client.id,
            })
            return next(clients) ~= nil
          end
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
    opts = {},
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
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
    branch = "master",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("philo.tree_setter")
    end,
  },

  ---------------------------------------------------------------------------
  -- LSP (Language Server Protocol)
  ---------------------------------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
    },
    config = function()
      require("philo.lsp")
    end,
  },

  {
    "mason-org/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUpdate" },
    config = function()
      require("philo.lsp.mason").setup()
    end,
  },

  { "mason-org/mason-lspconfig.nvim", lazy = true },

  -- Java LSP (filetype-specific)
  { "mfussenegger/nvim-jdtls", ft = "java" },

  ---------------------------------------------------------------------------
  -- Telescope (Fuzzy finder)
  ---------------------------------------------------------------------------
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-media-files.nvim",
    },
    keys = {
      {
        "<leader>ff",
        function()
          require("telescope.builtin").find_files(require("telescope.themes").get_dropdown({ previewer = false }))
        end,
        desc = "Find files",
      },
      {
        "<leader>F",
        function()
          require("telescope.builtin").find_files(require("telescope.themes").get_dropdown({ previewer = false }))
        end,
        desc = "Find files",
      },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { "<leader>fw", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Find help" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
      { "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Fuzzy find in buffer" },
      { "<leader>gf", "<cmd>Telescope git_files<cr>", desc = "Git files" },
      { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Git commits" },
      { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Git branches" },
      { "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Git status" },
      { "<leader>fW", "<cmd>Telescope grep_string<cr>", desc = "Find word under cursor" },
      { "<leader>fR", "<cmd>Telescope resume<cr>", desc = "Resume last search" },
      { "<leader>fc", "<cmd>Telescope command_history<cr>", desc = "Command history" },
      { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Search keymaps" },
      {
        "<leader>fd",
        function()
          require("telescope.builtin").find_files({ cwd = vim.fn.expand("%:p:h") })
        end,
        desc = "Find files in current dir",
      },
      { "<leader>fm", "<cmd>Telescope marks<cr>", desc = "Find marks" },
      { "<leader>fG", "<cmd>Telescope registers<cr>", desc = "Find registers" },
      { "<leader>fj", "<cmd>Telescope jumplist<cr>", desc = "Find jumplist" },
      { "<leader>fs", "<cmd>Telescope treesitter<cr>", desc = "Treesitter symbols" },
      { "<leader>fH", "<cmd>Telescope highlights<cr>", desc = "Find highlights" },
      {
        "<leader>ft",
        function()
          require("telescope.builtin").grep_string({ search = "TODO|FIXME|HACK|NOTE|XXX", use_regex = true })
        end,
        desc = "Find TODOs",
      },
      { "<leader>md", "<cmd>Telescope lsp_definitions<cr>", desc = "Go to definition" },
      { "<leader>lw", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Workspace symbols" },
      { "<leader>lo", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document symbols (outline)" },
      { "<leader>lD", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Buffer diagnostics" },
      { "<leader>lW", "<cmd>Telescope diagnostics<cr>", desc = "Workspace diagnostics" },
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
    keys = { { "<leader>mp", desc = "Format file or range", mode = { "n", "v" } } },
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

