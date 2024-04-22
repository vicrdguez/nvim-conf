-- [[ completion ]]
--
local cmp = require('cmp')
local luasnip = require('luasnip')
local compare = require('cmp.config.compare')

-- stolen from here: https://github.com/hrsh7th/nvim-cmp/issues/156#issuecomment-916338617
-- I want to give Fields more priority than methods f.e. this should do the trick
local kind_priority = {
    Field = 11,
    Property = 11,
    Constant = 10,
    Enum = 10,
    EnumMember = 10,
    Event = 10,
    Function = 10,
    Method = 10,
    Operator = 10,
    Reference = 10,
    Struct = 10,
    Variable = 9,
    File = 8,
    Folder = 8,
    Class = 5,
    Color = 5,
    Module = 5,
    Keyword = 2,
    Constructor = 1,
    Interface = 1,
    Snippet = 0,
    Text = 1,
    TypeParameter = 1,
    Unit = 1,
    Value = 1,
}

local lspkind_comparator = function(kind_priority)
    local lsp_types = require('cmp.types').lsp
    return function(entry1, entry2)
        if entry1.source.name ~= 'nvim_lsp' then
            if entry2.source.name == 'nvim_lsp' then
                return false
            else
                return nil
            end
        end
        local kind1 = lsp_types.CompletionItemKind[entry1:get_kind()]
        local kind2 = lsp_types.CompletionItemKind[entry2:get_kind()]

        local priority1 = kind_priority[kind1] or 0
        local priority2 = kind_priority[kind2] or 0
        if priority1 == priority2 then
            return nil
        end
        return priority2 < priority1
    end
end
-- Theft end

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
    sorting = {
        -- default cmp comparators, just changing 'kind' for the custom kind comparator
        comparators = {
            compare.offset,
            compare.exact,
            -- compare.scopes,
            compare.score,
            compare.recently_used,
            compare.locality,
            lspkind_comparator(kind_priority), --compare.kind,
            -- compare.sort_text,
            compare.length,
            compare.order,
        },
    },
    view = {
        entries = {
            follow_cursor = true
        }
    }
}
