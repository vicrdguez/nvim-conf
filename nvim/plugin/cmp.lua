-- [[ completion ]]
--
local cmp = require('cmp')
local luasnip = require('luasnip')

local function expand_jump_or_confirm()
    if luasnip.locally_jumpable(-1) then
        luasnip.expand_or_jump()
    end
end

local function jump_prev()
    if luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
    end
end

local cmp_select = { behavior = cmp.SelectBehavior.Select }

cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end
    },
    completion = { completeopt = 'menu,menuone,noinsert' },
    sources = {
        { name = 'nvim_lua' },
        { name = 'nvim_lsp' },
        { name = 'nvim_lsp_signature_help', keyword_length = 3 },
        { name = 'buffer',                  keyword_length = 3 },
        { name = 'luasnip',                 keyword_length = 2 },
        { name = 'path',                    keyword_length = 2 },
    },
    -- https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
    mapping = {
        -- ["<C-f>"] = cmp_action.luasnip_next_or_expand(),
        -- ["<C-b>"] = cmp_action.luasnip_jump_backward(),
        -- ["<Tab>"] = cmp_action.luasnip_supertab(),
        -- ["<S-Tab>"] = cmp_action.luasnip_shift_supertab(),
        ["<C-y>"] = cmp.mapping(expand_jump_or_confirm, { 'i', 's' }),
        ["<C-b>"] = cmp.mapping(jump_prev, { 'i', 's' }),
        ["<C-n>"] = cmp.mapping.scroll_docs(4),
        ["<C-p>"] = cmp.mapping.scroll_docs(-4),
        --["<C-m>"] = cycle_choice(cmp_select),
        ["<C-k>"] = cmp.mapping.select_prev_item(cmp_select),
        ["<C-j>"] = cmp.mapping.select_next_item(cmp_select),
        ["<C-f>"] = cmp.mapping.confirm({ select = true }),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
    },
    -- Adds some icons to each kind of completions
    formatting = {
        fields = { "abbr", "kind", "menu" },
        format = require("lspkind").cmp_format({
            mode = "symbol_text",
            -- maxwidth = 50,
            -- ellipsis_char = "...",
            -- show just the function name without the signature. we rely on the docs
            -- popoup for that
            before = function(_, vim_item)
                vim_item.abbr = vim_item.abbr:match("[^()]+")
                -- vim.notify("In kind", vim.log.levels.WARN)
                return vim_item
            end,
            menu = {
                buffer = "[buf]",
                nvim_lsp = "[LSP]",
                nvim_lua = "[api]",
                path = "[path]",
                luasnip = "[snip]",
            }
        })
    },
}
