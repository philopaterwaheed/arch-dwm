--[[
  Telescope Configuration
  
  Fuzzy finder for:
  - Files, buffers, grep
  - LSP symbols
  - Git files
  - And much more
--]]

local M = {}

M.setup = function()
  local status_ok, telescope = pcall(require, "telescope")
  if not status_ok then
    return
  end

  local actions = require("telescope.actions")

  telescope.setup({
    defaults = {
      prompt_prefix = " ",
      selection_caret = " ",
      path_display = { "smart" },
      file_ignore_patterns = { "node_modules", ".git/", "target/", "dist/" },
      
      mappings = {
        i = {
          ["<C-n>"] = actions.cycle_history_next,
          ["<C-p>"] = actions.cycle_history_prev,
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<C-c>"] = actions.close,
          ["<CR>"] = actions.select_default,
          ["<C-x>"] = actions.select_horizontal,
          ["<C-v>"] = actions.select_vertical,
          ["<C-t>"] = actions.select_tab,
          ["<C-u>"] = actions.preview_scrolling_up,
          ["<C-d>"] = actions.preview_scrolling_down,
          ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
          ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
          ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
          ["<C-_>"] = actions.which_key, -- <C-/>
        },
        n = {
          ["<esc>"] = actions.close,
          ["<CR>"] = actions.select_default,
          ["<C-x>"] = actions.select_horizontal,
          ["<C-v>"] = actions.select_vertical,
          ["<C-t>"] = actions.select_tab,
          ["j"] = actions.move_selection_next,
          ["k"] = actions.move_selection_previous,
          ["gg"] = actions.move_to_top,
          ["G"] = actions.move_to_bottom,
          ["<C-u>"] = actions.preview_scrolling_up,
          ["<C-d>"] = actions.preview_scrolling_down,
          ["?"] = actions.which_key,
        },
      },
    },
    pickers = {
      find_files = {
        hidden = true,
      },
    },
    extensions = {
      media_files = {
        filetypes = { "png", "webp", "jpg", "jpeg" },
        find_cmd = "rg",
      },
    },
  })

  -- Load extensions
  pcall(telescope.load_extension, "media_files")
end

return M
