return {
    {
        'tpope/vim-dadbod',
        lazy = true,
        dependencies = {
            'kristijanhusak/vim-dadbod-ui',
            'kristijanhusak/vim-dadbod-completion',
        },
        cmd = {
            'DB',
            'DBUI',
            'DBUIToggle',
            'DBUIAddConnection',
            'DBUIFindBuffer',
        },
        config = function()
            -- Optional: Add any dadbod-specific configuration here
            vim.g.db_ui_use_nerd_fonts = 1
        end,
    },
}
