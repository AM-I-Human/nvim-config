local function get_sources(names)
    local sources = { default = names, providers = {} }
    for _, name in ipairs(names) do
        sources.providers[name] = {
            name = name,
            module = 'blink.compat.source',
            score_offset = 1000,
            opts = {},
        }
    end
    return sources
end

return {
    'saghen/blink.cmp',
    dependencies = {
        'rafamadriz/friendly-snippets',
        'kristijanhusak/vim-dadbod-completion',
        {
            'saghen/blink.compat',
            opts = {},
            -- config = function()
            --     -- require('cmp').ConfirmBehavior = {
            --     --     Insert = 'insert',
            --     --     Replace = 'replace',
            --     -- }
            -- end,
        },
    },
    version = '*',
    -- build = 'cargo build --release',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        keymap = { preset = 'default' },

        appearance = {
            use_nvim_cmp_as_default = true,
            nerd_font_variant = 'mono',
        },

        sources = {
            default = {
                'lsp',
                'path',
                'snippets',
                'buffer',
                'dadbod',
                'avante_commands',
                'avante_mentions',
                'avante_files',
            },
            providers = {
                dadbod = { name = 'Dadbod', module = 'vim_dadbod_completion.blink' },
                avante_commands = {
                    name = 'avante_commands',
                    module = 'blink.compat.source',
                    score_offset = 90,
                    opts = {},
                },
                avante_files = {
                    name = 'avante_mentions',
                    module = 'blink.compat.source',
                    score_offset = 100,
                    opts = {},
                },
                avante_mentions = {
                    name = 'avante_mentions',
                    module = 'blink.compat.source',
                    score_offset = 1000,
                    opts = {},
                },
                otter_commands = {
                    name = 'otter_commands',
                    module = 'blink.compat.source',
                    score_offset = 1000,
                    opts = {},
                },
            },
        },
    },
    opts_extend = { 'sources.default' },
}
