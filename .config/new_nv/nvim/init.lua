-- Load core settings first (no dependencies, fast)
require("philo.options")
require("philo.keymaps")

-- Initialize plugin manager (handles all plugin loading)
require("philo.plugins")

-- Colorscheme (loaded after plugins are available)
require("philo.colorscheme")

-- UI components (loaded on VimEnter for faster startup)
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- Defer non-critical UI to after startup
    vim.schedule(function()
      require("philo.bar")        -- Statusline
      require("philo.buffer_line") -- Bufferline/tabline
      require("philo.dash")        -- Dashboard
    end)
  end,
  once = true,
})

-- Treesitter config (needed early for syntax highlighting)
require("philo.tree_setter")

-- Git integration (deferred, not needed immediately)
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    vim.schedule(function()
      require("philo.git")
    end)
  end,
  once = true,
})

-- Autocommands and events
require("philo.events")
