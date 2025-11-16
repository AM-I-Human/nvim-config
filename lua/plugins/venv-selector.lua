return {
    'linux-cultist/venv-selector.nvim',
    dependencies = {
        'neovim/nvim-lspconfig',
        'mfussenegger/nvim-dap', --optional
        'mfussenegger/nvim-dap-python', --optional
        { 'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim' } },
    },
    cmd = 'VenvSelect',
    keys = { '<leader>Pe' },
    config = true,
}
