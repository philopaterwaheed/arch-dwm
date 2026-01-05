--[[
  Completion Configuration (nvim-cmp)
  
  Provides:
  - LSP completions
  - Snippet completions (LuaSnip)
  - AI completions (Copilot, Codeium)
  - Buffer/path completions
--]]

local M = {}

M.setup = function()
  local cmp_status_ok, cmp = pcall(require, "cmp")
  if not cmp_status_ok then
    return
  end

  local snip_status_ok, luasnip = pcall(require, "luasnip")
  if not snip_status_ok then
    return
  end

  -- Load VSCode-style snippets
  require("luasnip.loaders.from_vscode").lazy_load()

  -- Check if we can expand or jump
  local check_backspace = function()
    local col = vim.fn.col(".") - 1
    return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
  end

  -- Kind icons for completion menu
  local kind_icons = {
    Text = "󰊄", Method = "", Function = "󰊕", Constructor = "",
    Field = "", Variable = "󰫧", Class = "", Interface = "",
    Module = "", Property = "", Unit = "", Value = "",
    Enum = "", Keyword = "󰌆", Snippet = "", Color = "",
    File = "", Reference = "", Folder = "", EnumMember = "",
    Constant = "", Struct = "", Event = "", Operator = "",
    TypeParameter = "󰉺", Copilot = "", Codeium = "",
  }

  cmp.setup({
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },

    mapping = cmp.mapping.preset.insert({
      ["<C-k>"] = cmp.mapping.select_prev_item(),
      ["<C-j>"] = cmp.mapping.select_next_item(),
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expandable() then
          luasnip.expand()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif check_backspace() then
          fallback()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
    }),

    formatting = {
      fields = { "kind", "abbr", "menu" },
      format = function(entry, vim_item)
        vim_item.kind = kind_icons[vim_item.kind] or ""
        vim_item.menu = ({
          nvim_lsp = "[LSP]",
          copilot = "[Copilot]",
          codeium = "[Codeium]",
          luasnip = "[Snippet]",
          buffer = "[Buffer]",
          path = "[Path]",
        })[entry.source.name]
        return vim_item
      end,
    },

    sources = cmp.config.sources({
      { name = "nvim_lsp", priority = 1000 },
      { name = "copilot", priority = 900 },
      { name = "codeium", priority = 800 },
      { name = "luasnip", priority = 750 },
      { name = "buffer", priority = 500 },
      { name = "path", priority = 250 },
    }),

    confirm_opts = {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    },

    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },

    experimental = {
      ghost_text = false, -- Disable inline completion preview
    },
  })

  -- Command line completion for '/'
  cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = "buffer" },
    },
  })

  -- Command line completion for ':'
  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = "path" },
    }, {
      { name = "cmdline" },
    }),
  })
end

return M
