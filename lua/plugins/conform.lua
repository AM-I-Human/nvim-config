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
                        '--dialect',
                        'snowflake',
                        '--disable-progress-bar',
                        '-',
                        '--force',
                    },
                    stdin = true,
                },
            },
        }
    end,
}
