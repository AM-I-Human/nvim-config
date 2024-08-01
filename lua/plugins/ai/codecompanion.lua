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
            strategies = {
                chat = {
                    adapter = 'ollama',
                },
                inline = {
                    adapter = 'ollama',
                },
                agent = {
                    adapter = 'ollama',
                },
            },
        }
    end,
}
