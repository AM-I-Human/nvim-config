return {
    'OXY2DEV/markview.nvim',
    dependencies = {
        'nvim-treesitter/nvim-treesitter',
        'nvim-tree/nvim-web-devicons',
    },
    branch = 'main',
    opts = {
        preview = {
            filetypes = { 'md', 'rmd', 'quarto', 'markdown', 'Avante', 'codecompanion' },
            ignore_buftypes = { 'nofile' },
        },
        max_length = 99999,
    },
}
