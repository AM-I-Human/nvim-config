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

            dap.listeners.after.event_initialized.dapui_config = dapui.open
            dap.listeners.before.event_terminated.dapui_config = dapui.close
            dap.listeners.before.event_exited.dapui_config = dapui.close

            require('nvim-dap-virtual-text').setup {
                display_callback = function(variable)
                    local name = string.lower(variable.name)
                    local value = string.lower(variable.value)
                    if name:match 'secret' or name:match 'api' or value:match 'secret' or value:match 'api' or value:match 'password' then
                        return '*****'
                    end
                    return ' ' .. variable.value
                end,
            }

            table.insert(dap.configurations.python, {
                type = 'python',
                request = 'launch',
                name = 'Python: Current File',
                program = '${file}',
                projectDir = '${workspaceFolder}',
                pythonPath = function()
                    return require('venv-selector').get_active_venv_python_path()
                end,
            })

            table.insert(dap.configurations.python, {
                -- Launch configuration for FastAPI with fastapi dev
                type = 'python',
                request = 'launch',
                name = 'FastAPI Dev',
                program = '${file}', -- This specifies the main file in your FastAPI project
                pythonPath = function()
                    return require('venv-selector').get_active_venv_python_path()
                end,
                args = { -- Arguments for `fastapi dev`
                    '-m',
                    'fastapi', -- Run the fastapi module
                    'dev', -- Use the `dev` command
                    'run',
                    'main.py', -- Specify the main FastAPI file
                    '--reload', -- Optional: automatically reloads server on file changes
                },
                justMyCode = true, -- Set to false if you want to debug inside dependencies
            })

            dap.listeners.before.launch.dapui_config = dapui.open()

            dapui.setup {
                icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
                controls = {
                    icons = {
                        pause = '⏸',
                        play = '▶',
                        step_into = '⏎',
                        step_over = '⏭',
                        step_out = '⏮',
                        step_back = 'b',
                        run_last = '▶▶',
                        terminate = '⏹',
                        disconnect = '⏏',
                    },
                },
            }

            dap.listeners.before.attach.dapui_config = function()
                ui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                ui.open()
            end
            dap.listeners.before.event_terminated.dapui_config = function()
                ui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
                ui.close()
            end
        end,
    },
}
