return {
    {
        'mfussenegger/nvim-dap',
        dependencies = {
            'rcarriga/nvim-dap-ui',
            'theHamsta/nvim-dap-virtual-text',
            'nvim-neotest/nvim-nio',
            'williamboman/mason.nvim',
            'jay-babu/mason-nvim-dap.nvim',
            'mfussenegger/nvim-dap-python',
            'leoluz/nvim-dap-go',
        },
        lazy = true,
        config = function()
            local dap = require 'dap'
            local dapui = require 'dapui'
            local dap_python = require 'dap-python'

            local mason_path = vim.fn.glob(vim.fn.stdpath 'data' .. '/mason/')
            local debugpy_path = mason_path .. 'packages/debugpy/venv/bin/python'
            if IS_WINDOWS then
                debugpy_path = mason_path .. 'packages/debugpy/venv/Scripts/python'
            end

            dapui.setup()
            dap_python.setup(debugpy_path)
            dap_python.default_port = 5678

            -- require('mason-nvim-dap').setup {
            --     automatic_installation = true,
            --     handlers = {},
            --     ensure_installed = {
            --         'python',
            --         'delve',
            --     },
            -- }
            dap.listeners.after.event_initialized.dapui_config = dapui.open
            dap.listeners.before.event_terminated.dapui_config = dapui.close
            dap.listeners.before.event_exited.dapui_config = dapui.close
            -- require('nvim-dap-virtual-text').setup {
            --     -- This just tries to mitigate the chance that I leak tokens here. Probably won't stop it from happening...
            --     display_callback = function(variable)
            --         local name = string.lower(variable.name)
            --         local value = string.lower(variable.value)
            --         if name:match 'secret' or name:match 'api' or value:match 'secret' or value:match 'api' then
            --             return '*****'
            --         end
            --
            --         if #variable.value > 15 then
            --             return ' ' .. string.sub(variable.value, 1, 15) .. '... '
            --         end
            --
            --         return ' ' .. variable.value
            --     end,
            -- }

            -- table.insert(dap.configurations.python, {
            --     type = 'python',
            --     request = 'launch',
            --     name = 'My custom launch configuration',
            --     program = '${file}',
            --     -- ... more options, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings
            -- })

            -- dap.adapters.go = {
            --     type = 'server',
            --     port = '${port}',
            --     executable = {
            --         command = 'dlv',
            --         args = { 'dap', '-l', '127.0.0.1:${port}' },
            --     },
            -- }

            -- local elixir_ls_debugger = vim.fn.exepath 'elixir-ls-debugger'
            -- if elixir_ls_debugger ~= '' then
            --     dap.adapters.mix_task = {
            --         type = 'executable',
            --         command = elixir_ls_debugger,
            --     }
            --
            --     dap.configurations.elixir = {
            --         {
            --             type = 'mix_task',
            --             name = 'phoenix server',
            --             task = 'phx.server',
            --             request = 'launch',
            --             projectDir = '${workspaceFolder}',
            --             exitAfterTaskReturns = false,
            --             debugAutoInterpretAllModules = false,
            --         },
            --     }
            -- end

            -- vim.keymap.set('n', '<space>b', dap.toggle_breakpoint)
            -- vim.keymap.set('n', '<space>gb', dap.run_to_cursor)
            --
            -- -- Eval var under cursor
            -- -- vim.keymap.set('n', '<space>?', function()
            -- --     require('dapui').eval(nil, { enter = true })
            -- -- end)
            --
            -- vim.keymap.set('n', '<F1>', dap.continue)
            -- vim.keymap.set('n', '<F2>', dap.step_into)
            -- vim.keymap.set('n', '<F3>', dap.step_over)
            -- vim.keymap.set('n', '<F4>', dap.step_out)
            -- vim.keymap.set('n', '<F5>', dap.step_back)
            -- vim.keymap.set('n', '<F13>', dap.restart)

            -- dap.listeners.before.launch.dapui_config = dapui.open()

            -- dapui.setup {
            --     icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
            --     controls = {
            --         -- icons = {
            --         --     pause = '⏸',
            --         --     play = '▶',
            --         --     step_into = '⏎',
            --         --     step_over = '⏭',
            --         --     step_out = '⏮',
            --         --     step_back = 'b',
            --         --     run_last = '▶▶',
            --         --     terminate = '⏹',
            --         --     disconnect = '⏏',
            --         -- },
            --     },
            -- }

            -- dap.listeners.before.attach.dapui_config = function()
            --     ui.open()
            -- end
            -- dap.listeners.before.launch.dapui_config = function()
            --     ui.open()
            -- end
            -- dap.listeners.before.event_terminated.dapui_config = function()
            --     ui.close()
            -- end
            -- dap.listeners.before.event_exited.dapui_config = function()
            --     ui.close()
            -- end
        end,
    },
}
