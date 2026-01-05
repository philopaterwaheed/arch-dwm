--[[
  Gitsigns Configuration
  
  Provides:
  - Git diff signs in the gutter
  - Hunk staging/unstaging
  - Blame annotations
  - Navigation between changes
--]]

require("gitsigns").setup({
  signs = {
    add = { text = "│" },
    change = { text = "│" },
    delete = { text = "󰍵" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
    untracked = { text = "┆" },
  },
  signcolumn = true,
  numhl = false,
  linehl = false,
  word_diff = false,
  watch_gitdir = { interval = 1000, follow_files = true },
  attach_to_untracked = true,
  current_line_blame = false, -- Toggle with <leader>gtb
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol",
    delay = 500,
  },
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil,
  max_file_length = 40000,
  preview_config = { border = "rounded", style = "minimal" },

  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation between hunks
    map("n", "]c", function()
      if vim.wo.diff then return "]c" end
      vim.schedule(function() gs.next_hunk() end)
      return "<Ignore>"
    end, { expr = true, desc = "Next hunk" })

    map("n", "[c", function()
      if vim.wo.diff then return "[c" end
      vim.schedule(function() gs.prev_hunk() end)
      return "<Ignore>"
    end, { expr = true, desc = "Previous hunk" })

    -- Actions (<leader>gh = git hunk)
    map("n", "<leader>ghs", gs.stage_hunk, { desc = "Stage hunk" })
    map("n", "<leader>ghr", gs.reset_hunk, { desc = "Reset hunk" })
    map("v", "<leader>ghs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Stage hunk" })
    map("v", "<leader>ghr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Reset hunk" })
    map("n", "<leader>ghS", gs.stage_buffer, { desc = "Stage buffer" })
    map("n", "<leader>ghu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
    map("n", "<leader>ghR", gs.reset_buffer, { desc = "Reset buffer" })
    map("n", "<leader>ghp", gs.preview_hunk, { desc = "Preview hunk" })
    map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, { desc = "Blame line" })
    map("n", "<leader>gtb", gs.toggle_current_line_blame, { desc = "Toggle line blame" })
    map("n", "<leader>ghd", gs.diffthis, { desc = "Diff this" })
    map("n", "<leader>ghD", function() gs.diffthis("~") end, { desc = "Diff this ~" })
    map("n", "<leader>gtd", gs.toggle_deleted, { desc = "Toggle deleted" })

    -- Text object for hunks
    map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select hunk" })
  end,
})
