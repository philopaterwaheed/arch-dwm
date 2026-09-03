--[[
  Gitsigns Configuration

  Upstream setup and keymaps: https://github.com/lewis6991/gitsigns.nvim
  Leader prefix kept as <leader>gh to match the rest of this config.
--]]

require("gitsigns").setup({
  signs = {
    add = { text = "┃" },
    change = { text = "┃" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
    untracked = { text = "┆" },
  },
  signs_staged = {
    add = { text = "┃" },
    change = { text = "┃" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
    untracked = { text = "┆" },
  },
  signs_staged_enable = true,
  signcolumn = true,
  numhl = false,
  linehl = false,
  word_diff = false,
  watch_gitdir = {
    follow_files = true,
  },
  auto_attach = true,
  attach_to_untracked = true,
  current_line_blame = false,
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol",
    delay = 1000,
    ignore_whitespace = false,
    virt_text_priority = 100,
    use_focus = true,
  },
  current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil,
  max_file_length = 40000,
  preview_config = {
    style = "minimal",
    relative = "cursor",
    row = 0,
    col = 1,
  },

  on_attach = function(bufnr)
    local gitsigns = require("gitsigns")

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buf = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map("n", "]c", function()
      if vim.wo.diff then
        vim.cmd.normal({ "]c", bang = true })
      else
        gitsigns.nav_hunk("next")
      end
    end, { desc = "Next hunk" })

    map("n", "[c", function()
      if vim.wo.diff then
        vim.cmd.normal({ "[c", bang = true })
      else
        gitsigns.nav_hunk("prev")
      end
    end, { desc = "Previous hunk" })

    -- Actions
    map("n", "<leader>ghs", gitsigns.stage_hunk, { desc = "Stage hunk" })
    map("n", "<leader>ghr", gitsigns.reset_hunk, { desc = "Reset hunk" })
    map("v", "<leader>ghs", function()
      gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, { desc = "Stage hunk" })
    map("v", "<leader>ghr", function()
      gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, { desc = "Reset hunk" })
    map("n", "<leader>ghS", gitsigns.stage_buffer, { desc = "Stage buffer" })
    map("n", "<leader>ghR", gitsigns.reset_buffer, { desc = "Reset buffer" })
    map("n", "<leader>ghp", gitsigns.preview_hunk, { desc = "Preview hunk" })
    map("n", "<leader>ghi", gitsigns.preview_hunk_inline, { desc = "Preview hunk inline" })
    map("n", "<leader>ghb", function()
      gitsigns.blame_line({ full = true })
    end, { desc = "Blame line" })
    map("n", "<leader>ghd", gitsigns.diffthis, { desc = "Diff this" })
    map("n", "<leader>ghD", function()
      gitsigns.diffthis("~")
    end, { desc = "Diff this ~" })
    map("n", "<leader>ghq", gitsigns.setqflist, { desc = "Hunks to qflist" })
    map("n", "<leader>ghQ", function()
      gitsigns.setqflist("all")
    end, { desc = "All hunks to qflist" })

    -- Toggles
    map("n", "<leader>gtb", gitsigns.toggle_current_line_blame, { desc = "Toggle line blame" })
    map("n", "<leader>gtw", gitsigns.toggle_word_diff, { desc = "Toggle word diff" })

    -- Text object
    map({ "o", "x" }, "ih", gitsigns.select_hunk, { desc = "Select hunk" })
  end,
})
