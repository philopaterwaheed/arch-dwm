--[[
  Comment.nvim Configuration
  
  Provides:
  - gcc to toggle line comment
  - gc to toggle selection comment
  - gbc for block comment
  - Treesitter integration for JSX/TSX
--]]

local M = {}

M.setup = function()
  local status_ok, comment = pcall(require, "Comment")
  if not status_ok then
    return
  end

  -- Check if ts_context_commentstring is available
  local ts_context_ok, ts_context = pcall(require, "ts_context_commentstring.integrations.comment_nvim")

  comment.setup({
    -- Use treesitter for determining comment style (JSX, TSX, etc.)
    pre_hook = ts_context_ok and ts_context.create_pre_hook() or nil,
  })
end

return M
