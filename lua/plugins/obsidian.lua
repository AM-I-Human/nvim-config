return {
    'epwalsh/obsidian.nvim',
    version = '*',
    event = {
        'BufReadPre T:\\MegaSyncFile\\*.md',
    },
    dependencies = {
        'nvim-lua/plenary.nvim',
    },
    opts = {
        workspaces = {
            {
                name = 'personal',
                path = 'T:\\MegaSyncFile\\*.md',
            },
            {
                name = 'work',
                path = '~/vaults/work',
            },
        },
    },
}
