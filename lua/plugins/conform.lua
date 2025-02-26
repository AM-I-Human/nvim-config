return {
    'stevearc/conform.nvim',
    lazy = true,
    event = { 'BufReadPre', 'BufNewFile' },
    keys = {
        {
            '<leader>f',
            function()
                require('conform').format { async = true, lsp_fallback = true }
            end,
            desc = '[F]ormat buffer',
        },
    },
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
                -- Add sqlfluff for SQL formatting, including Snowflake
                sql = { 'sqlfluff' },
            },
            formatters = {
                -- sqlfluff configuration
                sqlfluff = {
                    prepend_args = { 'lint', '--dialect', 'snowflake', '--fix' },
                    command = 'sqlfluff',
                },
            },
        }
    end,
}
