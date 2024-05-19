vim.opt.completeopt = { 'menu', 'menuone', 'preview' }
return { -- Autocompletion
    'hrsh7th/nvim-cmp',
    lazy = false,
    priority = 100,
    event = 'InsertEnter',
    dependencies = {
        'onsails/lspkind.nvim',
        -- Snippet Engine & its associated nvim-cmp source
        {
            'L3MON4D3/LuaSnip',
            build = (function()
                -- Build Step is needed for regex support in snippets.
                -- This step is not supported in many windows environments.
                -- Remove the below condition to re-enable on windows.
                if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
                    return
                end
                return 'make install_jsregexp'
            end)(),
            dependencies = {
                -- `friendly-snippets` contains a variety of premade snippets.
                --    See the README about individual language/framework/plugin snippets:
                --    https://github.com/rafamadriz/friendly-snippets
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
    },
    config = function()
        -- See `:help cmp`
        local cmp = require 'cmp'
        local luasnip = require 'luasnip'
        luasnip.config.setup {}
        local lspkind = require 'lspkind'
        lspkind.init {}

        cmp.setup {
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            completion = { completeopt = 'menu,menuone,noinsert' },

            -- For an understanding of why these mappings were
            -- chosen, you will need to read `:help ins-completion`
            --
            -- No, but seriously. Please read `:help ins-completion`, it is really good!
            mapping = cmp.mapping.preset.insert {
                -- Select the [n]ext item
                ['<C-n>'] = cmp.mapping.select_next_item(),
                -- Select the [p]revious item
                ['<C-p>'] = cmp.mapping.select_prev_item(),
                ['<C-y>'] = cmp.mapping(
                    cmp.mapping.confirm {
                        behavior = cmp.ConfirmBehavior.Insert,
                        select = true,
                    },
                    { 'i', 'c' }
                ),

                -- Scroll the documentation window [b]ack / [f]orward
                ['<C-b>'] = cmp.mapping.scroll_docs(-3),
                ['<C-f>'] = cmp.mapping.scroll_docs(3),

                -- If you prefer more traditional completion keymaps,
                -- you can uncomment the following lines
                -- ['<CR>'] = cmp.mapping.confirm { select = true },
                --['<Tab>'] = cmp.mapping.select_next_item(),
                --['<S-Tab>'] = cmp.mapping.select_prev_item(),

                -- Manually trigger a completion from nvim-cmp.
                --  Generally you don't need this, because nvim-cmp will display
                --  completions whenever it has completion options available.
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

                -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
                --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
            },
            sources = {
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
                { name = 'path' },
                { name = 'buffer' },
            },
        }

        -- Setup up vim-dadbod
        cmp.setup.filetype({ 'sql' }, {
            sources = {
                { name = 'vim-dadbod-completion' },
                { name = 'buffer' },
            },
        })

        local ls = require 'luasnip'
        ls.config.set_config {
            history = false,
            updateevents = 'TextChanged,TextChangedI',
        }

        for _, ft_path in ipairs(vim.api.nvim_get_runtime_file('snippets/*.lua', true)) do
            loadfile(ft_path)()
        end

        vim.keymap.set({ 'i', 's' }, '<c-k>', function()
            if ls.expand_or_jumpable() then
                ls.expand_or_jump()
            end
        end, { silent = true })

        vim.keymap.set({ 'i', 's' }, '<c-l>', function()
            if ls.jumpable(-1) then
                ls.jump(-1)
            end
        end, { silent = true })
    end,
}
