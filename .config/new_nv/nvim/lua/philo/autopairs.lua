--[[
  Autopairs Configuration
  
  Automatically closes brackets, quotes, etc.
  Integrates with nvim-cmp and treesitter
--]]

local M = {}

M.setup = function()
  local status_ok, npairs = pcall(require, "nvim-autopairs")
  if not status_ok then
    return
  end

  npairs.setup({
    check_ts = true, -- Use treesitter for smarter pairing
    ts_config = {
      lua = { "string", "source" },
      javascript = { "string", "template_string" },
      java = false, -- Disable for Java
    },
    disable_filetype = { "TelescopePrompt", "spectre_panel" },
    fast_wrap = {
      map = "<M-e>",
      chars = { "{", "[", "(", '"', "'" },
      pattern = [=[[%'%"%)%>%]%)%}%,]]=],
      offset = 0,
      end_key = "$",
      keys = "qwertyuiopzxcvbnmasdfghjkl",
      check_comma = true,
      highlight = "PmenuSel",
      highlight_grey = "LineNr",
    },
  })

  -- Integrate with nvim-cmp
  local cmp_autopairs = require("nvim-autopairs.completion.cmp")
  local cmp_status_ok, cmp = pcall(require, "cmp")
  if cmp_status_ok then
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end
end

return M
