local M = {}

local function extra_opts(cmp)
  local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0
      and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
  end

  local luasnip = require("luasnip")

  return {
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },

    mapping = cmp.mapping.preset.insert({
      ["<C-n>"] = cmp.mapping.select_next_item(),
      ["<C-p>"] = cmp.mapping.select_prev_item(),
      ["<A-u>"] = cmp.mapping.scroll_docs(-1),
      ["<A-d>"] = cmp.mapping.scroll_docs(1),
      ["<A-b>"] = cmp.mapping.scroll_docs(-8),
      ["<A-f>"] = cmp.mapping.scroll_docs(8),
      ["<C-Space>"] = cmp.mapping.complete({}),

      ["<CR>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          if luasnip.expandable() then
            luasnip.expand()
          else
            cmp.confirm({
              select = true,
            })
          end
        else
          fallback()
        end
      end),

      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.locally_jumpable(1) then
          luasnip.jump(1)
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { "i", "s" }),

      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.locally_jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
    }),

    sources = {
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "buffer" },
      { name = "path" },
      { name = "emoji" },
      { name = "calc" },
      {
        name = "dictionary",
        keyword_length = 2,
      },
    },
  }
end

function M.config(_, opts)
  local cmp = require("cmp")

  cmp.setup(vim.tbl_deep_extend("keep", opts, extra_opts(cmp)))

  cmp.setup.filetype("gitcommit", {
    sources = cmp.config.sources({
      { name = "git" },
    }, {
      { name = "buffer" },
    }),
  })

  local cmdmap = cmp.mapping.preset.cmdline({
    ["<CR>"] = {
      c = function(fallback)
        if not cmp.confirm({ select = false }) then
          fallback()
        end
      end,
    },
  })

  cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmdmap,
    sources = {
      { name = "buffer" },
    },
  })

  cmp.setup.cmdline(":", {
    mapping = cmdmap,
    sources = cmp.config.sources({
      { name = "path" },
    }, {
      { name = "cmdline" },
    }),
  })

  local cmp_autopairs = require("nvim-autopairs.completion.cmp")
  cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end

return M
