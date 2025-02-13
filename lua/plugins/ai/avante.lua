return {
    'yetone/avante.nvim',
    event = 'VeryLazy',
    lazy = false,
    version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
    build = (IS_WINDOWS and 'powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false') or 'make',
    dependencies = {
        'nvim-treesitter/nvim-treesitter',
        'nvim-tree/nvim-web-devicons',
        'stevearc/dressing.nvim',
        'nvim-lua/plenary.nvim',
        'MunifTanjim/nui.nvim',
        {
            'OXY2DEV/markview.nvim',
            opts = {
                file_types = { 'markdown', 'Avante' },
            },
            ft = { 'markdown', 'Avante' },
        },
        {
            'HakonHarnes/img-clip.nvim',
            event = 'VeryLazy',
            opts = {
                default = {
                    embed_image_as_base64 = false,
                    prompt_for_file_name = false,
                    drag_and_drop = {
                        insert_mode = true,
                    },
                    use_absolute_path = true,
                },
            },
        },
    },
    opts = {
        -- provider = 'ollama',
        provider = 'gemini',
        use_absolute_path = true,
        auto_suggestions_provider = 'ollama_autocomplete',
        gemini = {
            model = 'gemini-2.0-flash-exp',
            api_key_name = 'GEMINI_API_KEY',
            temperature = 0.7,
            max_tokens = 8192,
        },
        vendors = {
            ollama_autocomplete = {
                __inherited_from = 'openai',
                api_key_name = '',
                endpoint = 'http://localhost:11434/v1',
                model = 'qwen2.5-coder:7b',
            },
            ollama = {
                __inherited_from = 'openai',
                api_key_name = '',
                endpoint = 'http://localhost:11434/v1',
                model = 'deepseek-r1:32b',
                disable_tools = true,
            },
        },
        behaviour = {
            auto_suggestions = true, -- Experimental stage
            auto_set_highlight_group = true,
            auto_set_keymaps = true,
            auto_apply_diff_after_generation = false,
            support_paste_from_clipboard = true,
        },
        web_search_engine = {
            provider = 'google', --GOOGLE_SEARCH_API_KEY
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
                accept = '<Tab>',
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
