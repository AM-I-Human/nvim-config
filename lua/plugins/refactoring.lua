return {
    'ThePrimeagen/refactoring.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-treesitter/nvim-treesitter',
    },
    lazy = false,
    config = function()
        require('refactoring').setup()
        require('telescope').load_extension 'refactoring'
    end,
}
