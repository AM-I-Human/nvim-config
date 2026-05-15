return {
    'saghen/blink.compat',

    -- blink-edit is a separate plugin for ghost text
    {
        'saghen/blink.cmp',
        optional = true,
        opts = function(_, opts)
            -- Ensure blink-edit compatibility if needed, though usually it's standalone
            -- This block is just to ensure blink.cmp is loaded if present
            return opts
        end,
    },
    {
        'BlinkResearchLabs/blink-edit.nvim',
        event = 'InsertEnter', -- Load when entering insert mode for ghost text
        dependencies = { 'saghen/blink.cmp' }, -- Optional dependency for integration
        opts = {
            llm = {
                backend = IS_MAC and 'gemini' or 'ollama',
                provider = IS_MAC and 'zeta' or nil, -- Zeta prompt format works better for instruction-tuned models like Gemini
                -- Use specific model based on OS (Windows has 4090, Mac uses smaller model or connects to Windows)
                model = IS_MAC and 'gemini-3.1-flash-lite-preview' or 'qwen3.5:35b',
                url = IS_MAC and 'https://generativelanguage.googleapis.com' or 'http://localhost:11434',

                -- Keymaps for accepting/rejecting suggestions
                keymap = {
                    accept = '<Tab>', -- Tasto per accettare il suggerimento (come antigravity/cursor)
                    reject = '<Esc>',
                    accept_word = '<C-Right>',
                    accept_line = '<C-Down>',
                },

                -- Appearance settings
                appearance = {
                    -- Customize how the ghost text looks
                    ghost_text = {
                        enabled = true,
                    },
                },
            },
        },
    },
}
