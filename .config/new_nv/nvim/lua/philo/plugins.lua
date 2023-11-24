local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
-- Install your plugins here
local plugins = {
   {"nvim-lua/popup.nvim", event = "VimEnter",}, -- An implementation of the Popup API from vim in Neovim
   "nvim-lua/plenary.nvim", -- Useful lua functions used ny lots of plugins
   {"windwp/nvim-autopairs", 
    config = function()
     require("philo.autopairs").setup()
   end,
    event = "InsertEnter" 
   }, -- Autopairs, integrates with both cmp and treesitter
   'kyazdani42/nvim-web-devicons',
   {'kyazdani42/nvim-tree.lua',
	    config = function()
   	  require("philo.nvim-tree").setup()
   	end,
   	cmd = "NvimTreeToggle",
	},
   {"akinsho/toggleterm.nvim",
    config = function()
   	  require("philo.toggleterm").setup()
   	end,
     cmd = {
      "ToggleTerm",
      "TermExec",
      "ToggleTermToggleAll",
      "ToggleTermSendCurrentLine",
      "ToggleTermSendVisualLines",
      "ToggleTermSendVisualSelection",
    },
    keys = {"<C-\\>"} ,
   },
   "lukas-reineke/indent-blankline.nvim",
   {"mbbill/undotree", cmd = "UndotreeToggle"},
   "glepnir/dashboard-nvim",
   {"dstein64/vim-startuptime"},
   "lewis6991/impatient.nvim",
   {
	"norcalli/nvim-colorizer.lua",
	 config = function()
   	  require("philo.color").setup()
   	end,
	ft = {"css", "html", }, 
	},
   {"tpope/vim-fugitive",
	cmd ="G"; 
   },
  {
    "numToStr/Comment.nvim",
	 config = function()
   	  require("philo.comm").setup()
   	end,
    keys = {
      { "gcc", mode = "n", desc = "Comment toggle current line" },
      { "gc", mode = { "n", "o" }, desc = "Comment toggle linewise" },
      { "gc", mode = "x", desc = "Comment toggle linewise (visual)" },
      { "gbc", mode = "n", desc = "Comment toggle current block" },
      { "gb", mode = { "n", "o" }, desc = "Comment toggle blockwise" },
      { "gb", mode = "x", desc = "Comment toggle blockwise (visual)" },
    },
    dependencies = {'JoosepAlviste/nvim-ts-context-commentstring',}, 
    },
   {
    'lewis6991/gitsigns.nvim',
    dependencies= { 'nvim-lua/plenary.nvim' }
	},
-- Tabline
  "akinsho/bufferline.nvim",
  "moll/vim-bbye",
 -- cmp plugins
{
"folke/which-key.nvim", 
 event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  }
},
 {"hrsh7th/nvim-cmp", -- The completion plugin

	config = function()
     		require("philo.cmp").setup()
   	end,
	event =  { "InsertEnter", "CmdlineEnter" },

  	dependencies = 
	-- buffer completions
	{  
	  "hrsh7th/cmp-path", -- path completions
  	  "hrsh7th/cmp-cmdline", -- cmdline completions
  	  "saadparwaiz1/cmp_luasnip", -- snippet completions
  	  "hrsh7th/cmp-nvim-lsp",
  	  "hrsh7th/cmp-nvim-lua",
  	  "hrsh7th/cmp-buffer", 
	  "L3MON4D3/LuaSnip" ,--snippet engine
  	  "rafamadriz/friendly-snippets" ,-- a bunch of snippets to use
	},
  },


   -- Colorschemes
  -- use "lunarvim/colorschemes" -- A bunch of colorschemes you can try out
  "folke/tokyonight.nvim" , 
  {"lunarvim/darkplus.nvim", lazy = true,},
  {"navarasu/onedark.nvim",lazy = true,} , 
  {"nvim-lualine/lualine.nvim",lazy = true,},
  { 'Soares/base16.nvim',lazy = true,},
  {'Mofiqul/dracula.nvim',lazy = true,},
  --
    -- Treesitter
  "nvim-treesitter/nvim-treesitter" ,
  "p00f/nvim-ts-rainbow" , 
  {
	"AndrewRadev/tagalong.vim",
	dependencies = {"othree/html5.vim","tpope/vim-surround"},
	ft="html",
  },
  --use "nvim-treesitter/playground"
  -- snippets


  -- LSP
 "neovim/nvim-lspconfig", -- enable LSP
 {"mfussenegger/nvim-jdtls",
 	ft={"java"}
 },
 {"williamboman/mason.nvim",

	 config = function()
   	  require("philo.lsp.mason").setup()
   	end,
--cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
 }, -- simple to use language server installer
 
 "williamboman/mason-lspconfig.nvim", -- simple to use language server installer
 'jose-elias-alvarez/null-ls.nvim', -- LSP diagnostics and code actions
 "williamboman/nvim-lsp-installer", -- simple to use language server installer

  
  -- Telescope
   {"nvim-telescope/telescope.nvim",
	 config = function()
   	  require("philo.tel").setup()
   	end,
   dependencies = {'nvim-telescope/telescope-media-files.nvim'},
   cmd = "Telescope",
   },
  	
}
-- Example using a list of specs with the default options
require("lazy").setup(plugins)
