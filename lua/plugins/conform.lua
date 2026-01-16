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
                python = { 'ruff' }, -- Nota: ruff supporta già la configurazione standard, non serve la funzione complessa se non hai esigenze specifiche
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
                -- Se volevi mantenere la tua config custom di ruff per python:
                ruff = {
                    args = function(ctx)
                        return { 'check', '--fix', '--stdin-filename', ctx.filename, '-' }
                    end,
                },
            },
        }
    end,
}
