local M = {}

function M.set_bedrock_keys(profile)
    profile = profile or 'default'
    local credentials = vim.system({ 'aws', 'configure', 'export-credentials', '--profile', profile }, { text = true }):wait()
    if credentials.code ~= 0 then
        vim.notify(vim.trim(credentials.stderr), vim.log.levels.ERROR)
        return
    end
    local cred_data = vim.json.decode(credentials.stdout)
    local region = vim.system({ 'aws', 'configure', 'get', 'region', '--profile', profile }, { text = true }):wait()
    if region.code ~= 0 then
        vim.notify(vim.trim(region.stderr), vim.log.levels.ERROR)
        return
    end
    local region_text = vim.trim(region.stdout)
    local bedrock_keys = table.concat({
        cred_data.AccessKeyId,
        cred_data.SecretAccessKey,
        region_text,
        cred_data.SessionToken,
    }, ',')
    vim.env.BEDROCK_KEYS = bedrock_keys
    vim.notify(string.format('BEDROCK_KEYS set for profile %s in region %s', profile, region_text), vim.log.levels.INFO)
end

-- local provider = 'bedrock'
local provider = 'gemini'
-- if not IS_WINDOWS then
--     local aws_command = 'aws sts get-caller-identity --profile wsi-dev-ai'
--     local aws_check = vim.fn.system(aws_command)
--     local aws_success = vim.v.shell_error == 0
--
--     if aws_success then
--         print 'AWS CLI check successful, using Bedrock'
--         provider = 'bedrock'
--     else
--         print 'AWS CLI check failed or not on macOS, using Gemini'
--     end
-- end

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
        provider = provider,
        use_absolute_path = true,
        auto_suggestions_provider = 'ollama_autocomplete',
        bedrock = {
            model = 'anthropic.claude-3.5-sonnet-20241022-v1:0',
            timeout = 30000, -- Timeout in milliseconds
            temperature = 1, -- Adjust as needed
            max_tokens = 8192, -- Adjust as needed
            profile = 'wsi-dev-ai', -- Your AWS CLI profile name
        },
        claude = {
            endpoint = 'https://api.anthropic.com',
            model = 'claude-3-5-sonnet-20241022',
            temperature = 1,
            max_tokens = 8192,
        },
        gemini = {
            model = 'gemini-2.0-flash-thinking-exp-01-21',
            api_key_name = 'GEMINI_API_KEY',
            temperature = 1,
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
