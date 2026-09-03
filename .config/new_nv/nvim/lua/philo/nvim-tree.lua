--[[
  NvimTree File Explorer Configuration

  Upstream setup: https://github.com/nvim-tree/nvim-tree.lua
--]]

local M = {}

local function on_attach(bufnr)
  local api = require("nvim-tree.api")

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buf = bufnr, noremap = true, silent = true, nowait = true }
  end

  api.map.on_attach.default(bufnr)

  vim.keymap.set("n", "A", api.tree.expand_all, opts("Expand All"))
  vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
  vim.keymap.set("n", "C", api.tree.change_root_to_node, opts("CD"))
  vim.keymap.set("n", "gy", function()
    local node = api.tree.get_node_under_cursor()
    print(node.absolute_path)
  end, opts("Print Node Path"))
  vim.keymap.set("n", "Z", api.node.run.system, opts("Run System"))
end

M.setup = function()
  local status_ok, nvim_tree = pcall(require, "nvim-tree")
  if not status_ok then
    return
  end

  nvim_tree.setup({
    on_attach = on_attach,
    auto_reload_on_write = true,
    hijack_cursor = false,
    hijack_netrw = true,
    hijack_unnamed_buffer_when_opening = false,
    sync_root_with_cwd = false,
    respect_buf_cwd = false,

    sort = {
      sorter = "name",
      folders_first = true,
    },

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
      highlight_git = "name",
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
        web_devicons = {
          file = { enable = true, color = true },
          folder = { enable = false, color = true },
        },
        git_placement = "before",
        padding = { icon = " " },
        symlink_arrow = " ➛ ",
        show = {
          file = true,
          folder = true,
          folder_arrow = true,
          git = true,
          modified = true,
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
      update_root = {
        enable = false,
        ignore_list = {},
      },
    },

    diagnostics = {
      enable = false,
      show_on_dirs = false,
      show_on_open_dirs = true,
      debounce_delay = 50,
      severity = {
        min = vim.diagnostic.severity.HINT,
        max = vim.diagnostic.severity.ERROR,
      },
      icons = {
        hint = "💡",
        info = "🛈",
        warning = "⚠️",
        error = "❌",
      },
    },

    filters = {
      git_ignored = false,
      dotfiles = false,
      custom = { ".DS_Store", "__pycache__", ".pytest_cache" },
    },

    git = {
      enable = true,
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
