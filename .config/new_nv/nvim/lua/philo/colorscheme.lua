--[[
  Colorscheme Configuration
  
  Sets the active colorscheme with fallback handling
  Available themes: midnight, darkplus, onedark, dracula, base16
--]]

local colorscheme = "midnight"

local status_ok, _ = pcall(vim.cmd.colorscheme, colorscheme)
if not status_ok then
  vim.notify("Colorscheme '" .. colorscheme .. "' not found!", vim.log.levels.WARN)
  return
end
