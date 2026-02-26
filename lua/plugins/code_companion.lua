return {
    'olimorris/codecompanion.nvim',
    opts = {
        language = 'English',

        adapters = {
            -- Gli adapter classici (Gemini, OpenAI, Anthropic) ora vanno sotto "http"
            http = {
                gemini = function()
                    return require('codecompanion.adapters').extend('gemini', {
                        schema = {
                            model = {
                                default = 'gemini-3.1-pro-preview',
                            },
                        },
                    })
                end,
            },
        },

        strategies = {
            chat = {
                adapter = 'gemini',
                show_references = true,
                show_settings = true,
                show_token_count = true,
                keymaps = {
                    send = {
                        modes = { n = '<C-s>', i = '<C-s>' },
                    },
                    close = {
                        modes = { n = 'q', i = '<C-c>' },
                    },
                },
            },
            inline = {
                adapter = 'gemini',
                keymaps = {
                    accept_change = {
                        modes = { n = 'ga' },
                        description = 'Accept the suggested change',
                    },
                    reject_change = {
                        modes = { n = 'gr' },
                        description = 'Reject the suggested change',
                    },
                },
            },
            extensions = {
                -- Le tue estensioni
            },
        },
    },
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-treesitter/nvim-treesitter',
    },
}
