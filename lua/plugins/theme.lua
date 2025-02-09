return {
    'scottmckendry/cyberdream.nvim',
    lazy = false,
    priority = 1000,
    opts = {
        transparent = true,
        italic_comments = true,
        hide_fillchars = false,
        borderless_pickers = false,
        terminal_colors = true,
        cache = false, -- generate cache with :CyberdreamBuildCache and clear with :CyberdreamClearCache
        variant = 'default', -- use "light" for the light variant. Also accepts "auto" to set dark or light colors based on the current value of `vim.o.background`
        highlights = {},

        colors = {
            bg = '#000000',
            bgAlt = '#1e2124',
            bgHighlight = '#3c4048',
            fg = '#ffffff',
            grey = '#7b8496',
            blue = '#5ea1ff',
            green = '#5eff6c',
            cyan = '#5ef1ff',
            red = '#ff6e5e',
            yellow = '#f1ff5e',
            magenta = '#ff5ef1',
            pink = '#ff5ea0',
            orange = '#ffbd5e',
            purple = '#bd5eff',
        },
        extensions = {
            telescope = true,
            notify = true,
            mini = true,
        },
    },
    init = function(opts)
        vim.cmd 'colorscheme cyberdream'
    end,
}
