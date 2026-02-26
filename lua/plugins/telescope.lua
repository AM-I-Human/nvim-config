return {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    keys = {
        '<leader>s',
        'gd',
        'gr',
        'gI',
    },
    dependencies = {
        'nvim-lua/plenary.nvim',
        {
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'make',
            cond = function()
                return vim.fn.executable 'make' == 1
            end,
        },
        { 'nvim-telescope/telescope-ui-select.nvim' },
        { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
        {
            'nvim-telescope/telescope-file-browser.nvim',
            dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
        },
    },
    config = function()
        -- local fb_actions = require('telescope').extensions.file_browser.actions
        local actions = require 'telescope.actions'
        require('telescope').setup {
            -- You can put your default mappings / updates / etc. in here
            --  All the info you're looking for is in `:help telescope.setup()`
            --
            defaults = {
                mappings = {
                    i = { ['<c-f>'] = actions.to_fuzzy_refine },
                    n = { ['q'] = actions.close, ['F'] = actions.to_fuzzy_refine },
                },
            },
            -- pickers = {
            --     find_files = {
            --         theme = 'ivy',
            --     },
            -- },

            extensions = {
                fzf = {},
                ['ui-select'] = {
                    require('telescope.themes').get_dropdown(),
                },
                ['file-browser'] = {
                    file_browser = {
                        -- use the "ivy" theme if you want
                        theme = 'ivy',
                    },
                    mappings = {
                        ['i'] = {},
                        ['n'] = { q = 'close' },
                    },
                },
            },
        }

        -- Enable Telescope extensions if they are installed
        pcall(require('telescope').load_extension, 'fzf')
        pcall(require('telescope').load_extension, 'ui-select')
        pcall(require('telescope').load_extension, 'file-browser')

        -- Slightly advanced example of overriding default behavior and theme
        -- vim.keymap.set('n', '<leader>/', function()
        --     -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        --     require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        --         winblend = 10,
        --         previewer = false,
        --     })
        -- end, { desc = '[/] Fuzzily search in current buffer' })

        -- It's also possible to pass additional configuration options.
        --  See `:help telescope.builtin.live_grep()` for information about particular keys
    end,
}
