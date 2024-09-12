return {
    'yetone/avante.nvim',
    event = 'VeryLazy',
    lazy = false,
    build = 'powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false',
    dependencies = {
        'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
        'stevearc/dressing.nvim',
        'nvim-lua/plenary.nvim',
        'MunifTanjim/nui.nvim',

        --- The below is optional, make sure to setup it properly if you have lazy=true
        {
            'MeanderingProgrammer/render-markdown.nvim',
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
                model = 'codestral:22b',
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
    },
}
