-- completeopt but leave it for make sure it works
vim.opt.completeopt = { 'menu', 'menuone', 'preview' }
-- Autocompletion setup

return {
    'hrsh7th/nvim-cmp',
    lazy = false,
    priority = 100,
    event = 'InsertEnter',
    dependencies = {
        'onsails/lspkind.nvim',
        {
            'L3MON4D3/LuaSnip',
            build = (function()
                if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
                    return
                end
                return 'make install_jsregexp'
            end)(),
            dependencies = {
                {
                    'rafamadriz/friendly-snippets',
                    config = function()
                        require('luasnip.loaders.from_vscode').lazy_load()
                    end,
                },
            },
        },
        'saadparwaiz1/cmp_luasnip',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-buffer',
        'saadparwaiz1/cmp_luasnip',
        {
            'MattiasMTS/cmp-dbee',
            dependencies = {
                { 'kndndrj/nvim-dbee' },
            },
            ft = 'sql', -- optional but good to have
            opts = {}, -- needed
        },
    },
    config = function()
        -- See `:help cmp`
        local cmp = require 'cmp'
        local luasnip = require 'luasnip'
        local lspkind = require 'lspkind'

        -- Setup LuaSnip
        luasnip.config.setup {
            history = true,
            updateevents = 'TextChanged,TextChangedI',
        }

        -- Setup nvim-cmp
        cmp.setup {
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },

            completion = { completeopt = 'menu,menuone,noinsert' },
            window = {
                completion = {
                    scrollbar = true,
                    border = 'rounded',
                },
                documentation = {
                    scrollbar = true,
                    border = 'rounded',
                },
            },
            mapping = cmp.mapping.preset.insert {
                ['<C-n>'] = cmp.mapping.select_next_item(),
                ['<C-p>'] = cmp.mapping.select_prev_item(),
                ['<C-y>'] = cmp.mapping(
                    cmp.mapping.confirm {
                        behavior = cmp.ConfirmBehavior.Insert,
                        select = true,
                    },
                    { 'i', 'c' }
                ),
                ['<C-b>'] = cmp.mapping.scroll_docs(-3),
                ['<C-f>'] = cmp.mapping.scroll_docs(3),
                ['<C-Space>'] = cmp.mapping.complete {},
                ['<C-l>'] = cmp.mapping(function()
                    if luasnip.expand_or_locally_jumpable() then
                        luasnip.expand_or_jump()
                    end
                end, { 'i', 's' }),
                ['<C-h>'] = cmp.mapping(function()
                    if luasnip.locally_jumpable(-1) then
                        luasnip.jump(-1)
                    end
                end, { 'i', 's' }),
            },
            sources = {
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
                { name = 'otter' },
                { name = 'path' },
                { name = 'buffer' },
            },
        }

        -- Setup for SQL filetype
        cmp.setup.filetype({ 'sql' }, {
            sources = {
                { namne = 'cmp-dbee' },
                { name = 'vim-dadbod-completion' },
                { name = 'buffer' },
            },
        })

        -- Keymaps for LuaSnip
        vim.keymap.set({ 'i', 's' }, '<c-k>', function()
            if luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            end
        end, { silent = true })

        vim.keymap.set({ 'i', 's' }, '<c-l>', function()
            if luasnip.jumpable(-1) then
                luasnip.jump(-1)
            end
        end, { silent = true })

        require('luasnip.loaders.from_vscode').lazy_load()
        -- Initialize lspkind
        lspkind.init {
            -- enables text annotations
            --
            -- default: true
            mode = 'symbol_text',

            -- default symbol map
            -- can be either 'default' (requires nerd-fonts font) or
            -- 'codicons' for codicon preset (requires vscode-codicons font)
            --
            -- default: 'default'
            preset = 'default',

            -- override preset symbols
            --
            -- default: {}
            symbol_map = {
                Text = '󰉿',
                Method = '󰆧',
                Function = '󰊕',
                Constructor = '',
                Field = '󰜢',
                Variable = '',
                Class = '󰠱',
                Interface = '',
                Module = '',
                Property = '󰜢',
                Unit = '󰑭',
                Value = '󰎠',
                Enum = '',
                Keyword = '󰌋',
                Snippet = '',
                Color = '󰏘',
                File = '󰈙',
                Reference = '󰈇',
                Folder = '󰉋',
                EnumMember = '',
                Constant = '󰏿',
                Struct = '󰙅',
                Event = '',
                Operator = '󰆕',
                TypeParameter = '',
            },
        }
    end,
}
