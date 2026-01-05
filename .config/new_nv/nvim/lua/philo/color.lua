--[[
  Colorizer Configuration
  
  Highlights color codes in files (hex, rgb, etc.)
  Only enabled for relevant filetypes for performance
--]]

local M = {}

M.setup = function()
  local status_ok, colorizer = pcall(require, "colorizer")
  if not status_ok then
    return
  end

  colorizer.setup({
    "css",
    "html",
    "javascript",
    "typescript",
    "lua",
    css = { rgb_fn = true },  -- Enable parsing rgb(...) functions
    html = { names = false }, -- Disable parsing color names
  })
end

return M
