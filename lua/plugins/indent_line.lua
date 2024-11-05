return {
    {
        'lukas-reineke/indent-blankline.nvim',
        -- See `:help ibl`
        main = 'ibl',
        opts = {},
        config = function(opts)
            local highlight = {
                'IndentRainbowRed',
                'IndentRainbowYellow',
                'IndentRainbowBlue',
                'IndentRainbowOrange',
                'IndentRainbowGreen',
                'IndentRainbowViolet',
                'IndentRainbowCyan',
            }

            local hooks = require 'ibl.hooks'
            hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
                vim.api.nvim_set_hl(0, 'IndentRainbowRed', { fg = '#E06C75' })
                vim.api.nvim_set_hl(0, 'IndentRainbowYellow', { fg = '#E5C07B' })
                vim.api.nvim_set_hl(0, 'IndentRainbowBlue', { fg = '#61AFEF' })
                vim.api.nvim_set_hl(0, 'IndentRainbowOrange', { fg = '#D19A66' })
                vim.api.nvim_set_hl(0, 'IndentRainbowGreen', { fg = '#98C379' })
                vim.api.nvim_set_hl(0, 'IndentRainbowViolet', { fg = '#C678DD' })
                vim.api.nvim_set_hl(0, 'IndentRainbowCyan', { fg = '#56B6C2' })
                vim.api.nvim_set_hl(0, 'IndentScope', { fg = '#FFFFFF' })
            end)
            -- hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)

            require('ibl').setup {
                indent = { highlight = highlight, char = '┇' },
                scope = {
                    highlight = { 'IndentScope' },
                },
            }
        end,
    },
}
