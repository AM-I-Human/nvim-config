return {
    'yetone/avante.nvim',
    event = 'VeryLazy',
    lazy = false,
    build = IS_WINDOWS and 'powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false' or 'make',
    dependencies = {
        'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
        'stevearc/dressing.nvim',
        'nvim-lua/plenary.nvim',
        'MunifTanjim/nui.nvim',

        --- The below is optional, make sure to setup it properly if you have lazy=true
        {
            'OXY2DEV/markview.nvim',
            opts = {
                file_types = { 'markdown', 'Avante' },
            },
            ft = { 'markdown', 'Avante' },
        },
    },
    opts = {
        provider = 'ollama',
        use_absolute_path = true,
        vendors = {
            ollama = {
                ['local'] = true,
                endpoint = '127.0.0.1:11434/v1',
                -- model = "codegemma",
                model = 'qwen2.5:14b',
                parse_curl_args = function(opts, code_opts)
                    return {
                        url = opts.endpoint .. '/chat/completions',
                        headers = {
                            ['Accept'] = 'application/json',
                            ['Content-Type'] = 'application/json',
                        },
                        body = {
                            model = opts.model,
                            messages = require('avante.providers').copilot.parse_message(code_opts), -- you can make your own message, but this is very advanced
                            max_tokens = 2048,
                            stream = true,
                        },
                    }
                end,
                parse_response_data = function(data_stream, event_state, opts)
                    require('avante.providers').openai.parse_response(data_stream, event_state, opts)
                end,
            },
        },
        behaviour = {
            auto_suggestions = false, -- Experimental stage
            auto_set_highlight_group = true,
            auto_set_keymaps = true,
            auto_apply_diff_after_generation = false,
            support_paste_from_clipboard = false,
        },
        mappings = {
            --- @class AvanteConflictMappings
            diff = {
                ours = 'co',
                theirs = 'ct',
                all_theirs = 'ca',
                both = 'cb',
                cursor = 'cc',
                next = ']x',
                prev = '[x',
            },
            suggestion = {
                accept = '<M-l>',
                next = '<M-]>',
                prev = '<M-[>',
                dismiss = '<C-]>',
            },
            jump = {
                next = ']]',
                prev = '[[',
            },
            submit = {
                normal = '<CR>',
                insert = '<C-s>',
            },
        },
        hints = { enabled = true },
        windows = {
            ---@type "right" | "left" | "top" | "bottom"
            position = 'right', -- the position of the sidebar
            wrap = true, -- similar to vim.o.wrap
            width = 30, -- default % based on available width
            sidebar_header = {
                align = 'center', -- left, center, right for title
                rounded = true,
            },
        },
        highlights = {
            ---@type AvanteConflictHighlights
            diff = {
                current = 'DiffText',
                incoming = 'DiffAdd',
            },
        },
        --- @class AvanteConflictUserConfig
        diff = {
            autojump = true,
            ---@type string | fun(): any
            list_opener = 'copen',
        },
    },
}
