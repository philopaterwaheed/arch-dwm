--[[
  GitHub Copilot Configuration
  
  Provides AI-powered code completion
  Requires authentication: :Copilot auth
--]]

local M = {}

M.setup = function()
  local copilot_ok, copilot = pcall(require, "copilot")
  if not copilot_ok then
    return
  end

  copilot.setup({
    -- Disable built-in inline suggestions/panel (using copilot-cmp instead)
    suggestion = { enabled = false },
    panel = { enabled = false },
    -- Disable for certain filetypes
    filetypes = {
      yaml = false,
      markdown = false,
      help = false,
      gitcommit = false,
      gitrebase = false,
      ["."] = false,
    },
    copilot_node_command = "node", -- Node.js version must be > 18.x
  })
end

return M
