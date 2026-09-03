--[[
  Comment.nvim Configuration

  Upstream Comment.nvim + nvim-ts-context-commentstring integration:
  https://github.com/JoosepAlviste/nvim-ts-context-commentstring/wiki/Integrations#commentnvim
--]]

local M = {}

M.setup = function()
  local status_ok, comment = pcall(require, "Comment")
  if not status_ok then
    return
  end

  local ts_context_ok, ts_context = pcall(require, "ts_context_commentstring")
  if ts_context_ok then
    ts_context.setup({ enable_autocmd = false })
  end

  local pre_hook
  local integration_ok, integration = pcall(require, "ts_context_commentstring.integrations.comment_nvim")
  if integration_ok then
    pre_hook = integration.create_pre_hook()
  end

  comment.setup({
    pre_hook = pre_hook,
  })
end

return M
