return {
    'stevearc/conform.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
        require('conform').setup {
            notify_on_error = true,
            format_on_save = {
                timeout_ms = 1000,
                lsp_fallback = true,
            },

            formatters_by_ft = {
                lua = { 'stylua' },
                python = {
                    command = 'ruff',
                    args = function(ctx)
                        return { 'check', '--fix', '--stdin-filename', ctx.filename, '-' }
                    end,
                    stdin = true,
                },
                javascript = { 'biome' },
                typescript = { 'biome' },
                json = { 'biome' },
                jsonc = { 'biome' },
                markdown = { 'biome' },
                html = { 'biome' },
                sql = {
                    command = 'sqlfluff',
                    args = {
                        'format',
                        '--config "indentation.tab_space_size=4"',
                        '--config "templater=placeholder"',
                        '--config "templater:placeholder.param_style=ampersand"',
                        '--dialect',
                        'snowflake',
                        '-',
                    },
                    stdin = true,
                },
            },
        }
    end,
}
