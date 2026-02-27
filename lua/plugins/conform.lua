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

            -- 1. Definisci qui QUALI formatter usare per ogni filetype
            formatters_by_ft = {
                lua = { 'stylua' },
                python = { 'ruff_format', 'ruff_fix' }, -- Usa i formatter integrati di conform
                javascript = { 'biome' },
                typescript = { 'biome' },
                json = { 'biome' },
                markdown = { 'biome' },
                html = { 'biome' },
                -- Aggiungi SQL qui
                sql = { 'sqlfluff' },
            },

            -- 2. Definisci qui COME devono comportarsi i formatter specifici
            formatters = {
                sqlfluff = {
                    -- Sovrascrivi gli argomenti per impostare il dialetto (es. postgres, mysql, snowflake)
                    -- Nota: è meglio usare un file .sqlfluff nel progetto, ma puoi forzarlo qui
                    args = { 'format', '--dialect', 'ansi', '-' },
                },
            },
        }
    end,
}
