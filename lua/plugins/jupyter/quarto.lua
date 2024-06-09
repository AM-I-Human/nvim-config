return { -- requires plugins in lua/plugins/treesitter.lua and lua/plugins/lsp.lua
    -- for complete functionality (language features)
    'quarto-dev/quarto-nvim',
    ft = { 'quarto' },
    dev = false,
    opts = {
        debug = false,
        closePreviewOnExit = true,
        lspFeatures = {
            enabled = true,
            chunks = 'curly',
            languages = { 'r', 'python', 'julia', 'bash', 'lua', 'html', 'dot', 'javascript', 'typescript', 'ojs' },
            diagnostics = {
                enabled = true,
                triggers = { 'BufWritePost' },
            },
            completion = {
                enabled = true,
            },
        },
        codeRunner = {
            enabled = true,
            default_method = nil, -- 'molten' or 'slime'
            ft_runners = {}, -- filetype to runner, ie. `{ python = "molten" }`.
            -- Takes precedence over `default_method`
            never_run = { 'yaml' }, -- filetypes which are never sent to a code runner
        },
        keymap = {
            -- set whole section or individual keys to `false` to disable
            hover = 'K',
            definition = 'gd',
            type_definition = 'gD',
            rename = '<leader>lR',
            format = '<leader>lf',
            references = 'gr',
            document_symbols = 'gS',
        },
    },
    dependencies = {
        -- for language features in code cells
        -- configured in lua/plugins/lsp.lua and
        -- added as a nvim-cmp source in lua/plugins/completion.lua
        'jmbuhr/otter.nvim',
    },
}
