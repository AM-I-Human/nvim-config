return {
    'linux-cultist/venv-selector.nvim',
    dependencies = {
        'neovim/nvim-lspconfig',
        'mfussenegger/nvim-dap', --optional
        'mfussenegger/nvim-dap-python', --optional
        { 'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim' } },
    },
    event = 'VeryLazy',
    branch = 'regexp',
    config = function(_, opts)
        require('venv-selector').setup(opts)
        vim.api.nvim_create_autocmd('VimEnter', {
            desc = 'Auto select virtualenv Nvim open',
            pattern = { '*.py', '*.ipynb', '*.md' },
            group = vim.api.nvim_create_augroup('venv_selector_auto', {}),
            callback = function()
                local venv = vim.fn.findfile('pyproject.toml', vim.fn.getcwd() .. ';')
                if venv ~= '' then
                    require('venv-selector').retrieve_from_cache()
                end
            end,
            once = true,
        })
    end,
}
