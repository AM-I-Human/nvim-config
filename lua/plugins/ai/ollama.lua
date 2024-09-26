return {
    'nomnivore/ollama.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
    },

    -- All the user commands added by the plugin
    cmd = { 'Ollama', 'OllamaModel', 'OllamaServe', 'OllamaServeStop' },

    keys = {
        -- -- Sample keybind for prompt menu. Note that the <c-u> is important for selections to work properly.
        -- {
        --   "<leader>oo",
        --   ":<c-u>lua require('ollama').prompt()<cr>",
        --   desc = "ollama prompt",
        --   mode = { "n", "v" },
        -- },
        --
        -- -- Sample keybind for direct prompting. Note that the <c-u> is important for selections to work properly.
        -- {
        --   "<leader>oG",
        --   ":<c-u>lua require('ollama').prompt('Generate_Code')<cr>",
        --   desc = "ollama Generate Code",
        --   mode = { "n", "v" },
        -- },
    },

    ---@type Ollama.Config
    opts = {
        model = 'codegeex4', -- The default model to use.
        url = 'http://127.0.0.1:11434',
        serve = {
            on_start = false,
            command = 'ollama',
            args = { 'serve' },
            stop_command = 'pkill',
            stop_args = { '-SIGTERM', 'ollama' },
        },
        -- View the actual default prompts in ./lua/ollama/prompts.lua
        prompts = {
            Sample_Prompt = {
                prompt = 'This is a sample prompt that receives $input and $sel(ection), among others.',
                input_label = '> ',
                model = 'codegeex4', -- The default model to use.
                action = 'display',
            },
            Fast_virtual_prediction = {
                prompt = 'Given this code $buf, ',
                model = 'codegeex4:9b-all-q2_K',
                action = 'display',
                -- ---@type Ollama.PromptAction
                -- action = {
                --     fn = function(prompt)
                --         -- This function is called when the prompt is selected
                --         -- just before sending the prompt to the LLM.
                --         -- Useful for setting up UI or other state.
                --
                --         -- Return a function that will be used as a callback
                --         -- when a response is received.
                --         ---@type Ollama.PromptActionResponseCallback
                --         return function(body, job)
                --             -- body is a table of the json response
                --             -- body.response is the response text received
                --
                --             -- job is the plenary.job object when opts.stream = true
                --             -- job is nil otherwise
                --         end
                --     end,
                --
                --     opts = { stream = true }, -- optional, default is false
                -- },
            },
        },
    },
}
