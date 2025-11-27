-- local provider = 'bedrock'
local provider = 'gemini'

return {
    'yetone/avante.nvim',
    event = 'VeryLazy',
    version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
    build = (IS_WINDOWS and 'powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false') or 'make',

    dependencies = {
        'nvim-treesitter/nvim-treesitter',
        'nvim-tree/nvim-web-devicons',
        'stevearc/dressing.nvim',
        'nvim-lua/plenary.nvim',
        'MunifTanjim/nui.nvim',
        'echasnovski/mini.pick',
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
        -- system_prompt as function ensures LLM always has latest MCP server state
        -- This is evaluated for every message, even in existing chats
        -- system_prompt = function()
        --     -- local hub = require('mcphub').get_hub_instance()
        --     return hub and hub:get_active_servers_prompt() or ''
        -- end,
        -- -- Using function prevents requiring mcphub before it's loaded
        -- custom_tools = function()
        --     return {
        --         require('mcphub.extensions.avante').mcp_tool(),
        --     }
        -- end,
        provider = provider,
        use_absolute_path = true,
        -- auto_suggestions_provider = 'ollama_autocomplete',
        providers = {
            ollama_autocomplete = {
                __inherited_from = 'openai',
                api_key_name = '',
                endpoint = 'http://localhost:11434/v1',
                model = 'gemma3:4b',
                extra_request_body = {
                    temperature = 0,
                },
            },
            ollama = {
                __inherited_from = 'openai',
                api_key_name = '',
                endpoint = 'http://localhost:11434/v1',
                model = 'deepseek-r1:32b',
                extra_request_body = {
                    temperature = 0,
                },
            },
            gemini = {
                model = 'gemini-3.0-pro-preview',
                extra_request_body = {
                    temperature = 0,
                    max_tokens = 8192,
                },
                use_tools = false,
            },
        },
        behaviour = {
            auto_suggestions = false, -- Experimental stage
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
            autojump = false,
            ---@type string | fun(): any
            list_opener = 'copen',
        },
    },
}
