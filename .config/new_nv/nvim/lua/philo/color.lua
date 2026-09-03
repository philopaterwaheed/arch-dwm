--[[
  Colorizer Configuration

  Highlights color codes in files (hex, rgb, etc.)
  Maintained fork: https://github.com/catgoose/nvim-colorizer.lua
--]]

local M = {}

M.setup = function()
  local status_ok, colorizer = pcall(require, "colorizer")
  if not status_ok then
    return
  end

  colorizer.setup({
    filetypes = {
      "css",
      "html",
      "javascript",
      "typescript",
      "lua",
      css = { rgb_fn = true },
      html = { names = false },
    },
  })
end

return M
