return {
    'olimorris/codecompanion.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-treesitter/nvim-treesitter',
        'nvim-telescope/telescope.nvim', -- Optional
        {
            'stevearc/dressing.nvim', -- Optional: Improves the default Neovim UI
            opts = {},
        },
    },
    config = function(opts)
        require('codecompanion').setup {
            adapters = {
                codestral = function()
                    return require('codecompanion.adapters').use('ollama', {
                        schema = {
                            model = {
                                default = 'codestral:latest',
                            },
                        },
                    })
                end,
            },
            strategies = {
                chat = {
                    adapter = 'codestral',
                },
                inline = {
                    adapter = 'codestral',
                },
                agent = {
                    adapter = 'codestral',
                },
            },
        }
    end,
}
