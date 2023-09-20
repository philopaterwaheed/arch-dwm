-- Attaches to every FileType mode

-- Attach to certain Filetypes, add special configuration for `html`
-- Use `background` for everything else.
--require 'colorizer'.setup {
--  'css';
--  'javascript';
--  html = {
--   mode = 'foreground';}
--  '*'; -- Highlight all files, but customize some others.
--  css = { rgb_fn = true; }; -- Enable parsing rgb(...) functions in css.
--  html = { names = false; }; -- Disable parsing "names" like Blue or Gray
--}

local M = {}
M.setup = function()
require 'colorizer'.setup {
  '!*'; -- Highlight all files, but customize some others.
  'h';
  css = { rgb_fn = true; }; -- Enable parsing rgb(...) functions in css.
  html = { names = false; } -- Disable parsing "names" like Blue or Gray
}
end 
return M
