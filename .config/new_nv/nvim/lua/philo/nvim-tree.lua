--[[
  NvimTree File Explorer Configuration
  
  Provides:
  - File tree sidebar
  - Git integration
  - File operations (create, rename, delete)
--]]

local M = {}

M.setup = function()
  local status_ok, nvim_tree = pcall(require, "nvim-tree")
  if not status_ok then
    return
  end

  nvim_tree.setup({
    auto_reload_on_write = true,
    hijack_cursor = false,
    hijack_netrw = true,
    hijack_unnamed_buffer_when_opening = false,
    sort_by = "name",
    sync_root_with_cwd = false,
    respect_buf_cwd = false,
    
    -- Use the on_attach defined in keymaps.lua
    on_attach = _G.nvim_tree_on_attach or "default",

    view = {
      width = 34,
      side = "left",
      preserve_window_proportions = false,
      number = false,
      relativenumber = false,
      signcolumn = "yes",
    },

    renderer = {
      add_trailing = false,
      group_empty = false,
      highlight_git = true,
      full_name = false,
      highlight_opened_files = "name",
      indent_width = 2,
      indent_markers = {
        enable = true,
        icons = {
          corner = "└",
          edge = "│",
          item = "│",
          bottom = "─",
          none = " ",
        },
      },
      icons = {
        webdev_colors = true,
        git_placement = "before",
        padding = " ",
        symlink_arrow = " ➛ ",
        show = {
          file = true,
          folder = true,
          folder_arrow = true,
          git = true,
          modified = true,
        },
        glyphs = {
          default = "",
          symlink = "",
          bookmark = "",
          modified = "●",
          folder = {
            arrow_closed = "",
            arrow_open = "",
            default = "",
            open = "",
            empty = "",
            empty_open = "",
            symlink = "",
            symlink_open = "",
          },
          git = {
            unstaged = "✗",
            staged = "✓",
            unmerged = "",
            renamed = "➜",
            untracked = "★",
            deleted = "",
            ignored = "◌",
          },
        },
      },
      special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
    },

    hijack_directories = {
      enable = true,
      auto_open = true,
    },

    update_focused_file = {
      enable = true,
      update_root = false,
      ignore_list = {},
    },

  diagnostics = {
      enable = false,
      show_on_dirs = false,
      show_on_open_dirs = true,
      debounce_delay = 50,
      severity = {
        min = vim.diagnostic.severity.HINT,
        max = vim.diagnostic.severity.ERROR
      },
      icons = {
        hint = "💡",
        info = "🛈",
        warning = "⚠️",
        error = "❌",
      },
    },
    filters = {
      dotfiles = false,
      custom = { ".DS_Store", "__pycache__", ".pytest_cache" },
    },

    git = {
      enable = true,
      ignore = false,
      show_on_dirs = true,
      timeout = 400,
    },

    actions = {
      use_system_clipboard = true,
      open_file = {
        quit_on_open = false,
        resize_window = true,
        window_picker = {
          enable = true,
          chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
          exclude = {
            filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
            buftype = { "nofile", "terminal", "help" },
          },
        },
      },
    },

    trash = {
      cmd = "gio trash",
    },
  })
end

return M
