return {
    'OXY2DEV/markview.nvim',
    lazy = false,
    event = 'VeryLazy',
    dependencies = {
        'nvim-treesitter/nvim-treesitter',
        'nvim-tree/nvim-web-devicons',
    },
    opts = {
        file_types = { 'markdown', 'Avante' },
    },
    ft = { 'markdown', 'Avante' },
}
