return {
    'nvim-neotest/neotest',
    dependencies = {
        'nvim-neotest/nvim-nio',
        'nvim-lua/plenary.nvim',
        'antoinemadec/FixCursorHold.nvim',
        'nvim-treesitter/nvim-treesitter',
    },
    config = function()
        require('neotest').setup {
            adapters = {
                require 'neotest-python' {
                    -- Extra arguments for nvim-dap configuration
                    -- See https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for values
                    python = '.venv/Scripts/python',
                    dap = {
                        justMyCode = false,
                        console = 'integratedTerminal',
                    },
                    args = { '--log-level', 'DEBUG', '--quiet' },
                    runner = 'pytest',
                },
                -- require 'neotest-plenary',
            },
        }
    end,
}
