return {
    'olimorris/codecompanion.nvim',
    opts = {
        language = 'English',
        -- system_prompt = function(opts)
        --      return "My new system prompt"
        --    end,
        strategies = {
            chat = {
                show_references = true,
                show_settings = true,
                show_token_count = true,
                model = 'gemini-2.5-pro-preview-03-25', -- Specify the model for chat
                keymaps = {
                    send = {
                        modes = { n = '<C-s>', i = '<C-s>' },
                    },
                    close = {
                        modes = { n = 'q', i = '<C-c>' },
                    },
                    -- Add further custom keymaps here
                },
                adapter = 'gemini',
                -- tools = {
                --         ["my_tool"] = {
                --           description = "Run a custom task",
                --           callback = require("user.codecompanion.tools.my_tool")
                --         },
                --         groups = {
                --           ["my_group"] = {
                --             description = "A custom agent combining tools",
                --             system_prompt = "Describe what the agent should do",
                --             tools = {
                --               "cmd_runner",
                --               "editor",
                --               -- Add your own tools or reuse existing ones
                --             },
                --           },
                --         },
                -- ["cmd_runner"] = {
                --   opts = {
                --     requires_approval = false,
                --   },
                -- },
                --         },
            },
            inline = {
                adapter = 'gemini',
                model = 'gemini-2.5-pro-preview-03-25', -- Specify the model for chat
                keymaps = {
                    accept_change = {
                        modes = { n = 'ga' },
                        description = 'Accept the suggested change',
                    },
                    reject_change = {
                        modes = { n = 'gr' },
                        description = 'Reject the suggested change',
                    },
                },
            },
        },
    },
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-treesitter/nvim-treesitter',
    },
}
