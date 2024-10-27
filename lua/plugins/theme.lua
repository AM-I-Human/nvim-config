return {
    'scottmckendry/cyberdream.nvim',
    lazy = false,
    priority = 1000,
    opts = {
        -- Enable transparent background
        transparent = false,

        -- Enable italics comments
        italic_comments = true,

        -- Replace all fillchars with ' ' for the ultimate clean look
        hide_fillchars = false,

        -- Modern borderless telescope theme - also applies to fzf-lua
        borderless_telescope = false,

        -- Set terminal colors used in `:terminal`
        terminal_colors = true,

        -- Use caching to improve performance - WARNING: experimental feature - expect the unexpected!
        -- Early testing shows a 60-70% improvement in startup time. YMMV. Disables dynamic light/dark theme switching.
        cache = false, -- generate cache with :CyberdreamBuildCache and clear with :CyberdreamClearCache

        theme = {
            variant = 'default', -- use "light" for the light variant. Also accepts "auto" to set dark or light colors based on the current value of `vim.o.background`
            highlights = {
                -- Highlight groups to override, adding new groups is also possible
                -- See `:h highlight-groups` for a list of highlight groups or run `:hi` to see all groups and their current values

                -- Example:
                -- Comment = { fg = '#696969', bg = 'NONE', italic = true },

                -- Complete list can be found in `lua/cyberdream/theme.lua`
            },

            -- Override a highlight group entirely using the color palette
            -- overrides = function(colors) -- NOTE: This function nullifies the `highlights` option
            --     -- Example:
            --     return {
            --         Comment = { fg = colors.green, bg = 'NONE', italic = true },
            --         ['@property'] = { fg = colors.magenta, bold = true },
            --     }
            -- end,

            -- Override a color entirely
            colors = {
                -- For a list of colors see `lua/cyberdream/colours.lua`
                -- Example:
                bg = '#000000',
                -- bg = '#16181a',
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
        },

        -- -- Disable or enable colorscheme extensions
        extensions = {
            telescope = true,
            notify = true,
            mini = true,
            ...,
        },
    },
    init = function(opts)
        vim.cmd 'colorscheme cyberdream'
    end,
}
