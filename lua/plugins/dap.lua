return {
    'mfussenegger/nvim-dap',
    dependencies = {
        'rcarriga/nvim-dap-ui',
        'theHamsta/nvim-dap-virtual-text',
        'nvim-neotest/nvim-nio',
        'williamboman/mason.nvim',
        'jay-babu/mason-nvim-dap.nvim', -- Ensures adapters are installed and configured
        'mfussenegger/nvim-dap-python',
        'leoluz/nvim-dap-go',
    },
    config = function()
        -- 1. Enable DAP logging for debugging. This is the most impMasonInstall python-debugpyortant step.
        -- Log file will be at C:\\Users\\<user>\\AppData\\Local\\nvim-data\\dap.log
        require('dap').set_log_level 'TRACE'

        local dap = require 'dap'
        local dapui = require 'dapui'

        -- 2. Let mason-nvim-dap handle the setup of adapters.
        -- This automatically installs and configures debugpy, delg, etc.
        -- It's much more reliable than setting paths manually.
        require('mason-nvim-dap').setup {
            ensure_installed = { 'python' }, -- Adapters you want installed
            automatic_installation = true, -- Automatically install new adapters
            handlers = {}, -- Use the default handlers
        }
        if IS_WINDOWS then
            python_adapter_path = vim.fn.stdpath 'data' .. '/mason/packages/debugpy/venv/Scripts/python.exe'
        else
            python_adapter_path = vim.fn.stdpath 'data' .. '/mason/packages/debugpy/venv/bin/python'
        end
        dap.adapters.python = {
            type = 'executable',
            command = python_adapter_path,
            args = { '-m', 'debugpy.adapter' },
        }

        -- This replaces your manual dap-python.setup() and path logic.
        -- mason-nvim-dap will now correctly configure the python debugger (debugpy).

        dapui.setup {
            icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
            controls = {
                enabled = true,
                element = 'repl',
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

        require('nvim-dap-virtual-text').setup {
            -- Your virtual text setup remains the same
            display_callback = function(variable)
                local name = string.lower(variable.name)
                local value = string.lower(variable.value)
                if name:match 'secret' or name:match 'api' or value:match 'secret' or value:match 'api' or value:match 'password' then
                    return '*****'
                end
                return ' ' .. variable.value
            end,
        }

        -- 3. Simplified Launch Configurations
        -- Your configurations for python can be simplified. `mason-nvim-dap` already
        -- sets up a default configuration. You can add more as needed.
        dap.configurations.python = {
            {
                type = 'python',
                request = 'launch',
                name = 'Launch file',
                program = '${file}',
                pythonPath = function()
                    local venv = require('venv-selector').python()
                    if venv then
                        return venv
                    end
                    vim.notify('Python venv not selected, falling back to global python', vim.log.levels.WARN)
                    return 'python'
                end,
                justMyCode = true,
            },
            {
                type = 'python',
                request = 'launch',
                name = 'FastAPI: uvicorn',
                module = 'uvicorn',
                args = {
                    'main:app', -- Assuming your app instance is in main.py
                    '--reload',
                    '--host',
                    '127.0.0.1',
                    '--port',
                    '8000',
                },
                jinja = 'py', -- Allows for expression evaluation in args
                justMyCode = true,
            },
            {
                type = 'python',
                request = 'launch',
                name = 'UV run',
                program = function()
                    return vim.fn.expand '%:p'
                end,
                pythonPath = require('venv-selector').python(),
                justMyCode = true,
            },
        }

        dap.listeners.before.launch.dapui_config = dapui.open
        dap.listeners.after.event_initialized.dapui_config = dapui.open
        dap.listeners.before.event_terminated.dapui_config = dapui.close
        dap.listeners.before.event_exited.dapui_config = dapui.close

        dap.listeners.before.attach.dapui_config = dapui.open
        dap.listeners.before.launch.dapui_config = dapui.open
        dap.listeners.before.event_terminated.dapui_config = dapui.close
        dap.listeners.before.event_exited.dapui_config = dapui.close

        -- Helper function to get all leader mappings (including which-key)
        local function get_all_leader_mappings(mode)
            local leader = vim.g.mapleader
            local mappings = {}
            local all_maps = vim.keymap.get(mode)
            for _, map in ipairs(all_maps) do
                if string.sub(map.lhs, 1, #leader) == leader then
                    table.insert(mappings, map)
                end
            end
            return mappings
        end

        -- Store original leader mappings *per mode*
        local original_leader_mappings = {}

        local function set_dap_ui_keymap(map_data)
            local modes = type(map_data.mode) == 'string' and { map_data.mode } or map_data.mode
            for _, mode in ipairs(modes) do
                -- We no longer save here, we'll save in the which_key_on_config_setup
                -- Set DAP UI keymap
                local opts = {
                    buffer = true,
                    desc = map_data.desc,
                    noremap = map_data.noremap,
                    silent = map_data.silent,
                }
                local ok, err = pcall(vim.keymap.set, mode, map_data.key, map_data.func, opts)
                if not ok then
                    vim.notify('Failed to set dapui mapping: ' .. tostring(err), vim.log.levels.WARN)
                end
            end
        end

        local function restore_dap_ui_keymaps(mode)
            if not original_leader_mappings[mode] then
                return
            end
            -- First, *delete* all leader mappings in the given mode. This is crucial.
            local leader = vim.g.mapleader
            local all_maps = vim.keymap.get(mode)
            for _, map in ipairs(all_maps) do
                if string.sub(map.lhs, 1, #leader) == leader then
                    vim.keymap.del(mode, map.lhs, { buffer = map.buffer }) --Important, delete the buffer local, or global map.
                end
            end

            -- Then, restore the original mappings.
            for _, mapping in ipairs(original_leader_mappings[mode]) do
                -- No need to delete
                local success, err = pcall(vim.keymap.set, mode, mapping.lhs, mapping.rhs, mapping.opts)
                if not success then
                    vim.notify(
                        'Failed to restore WhichKey mapping: ' .. string.format('mode=%s, lhs=%s, error=%s', mode, mapping.lhs, tostring(err)),
                        vim.log.levels.WARN
                    )
                end
            end
            original_leader_mappings[mode] = nil -- Clear after restoring
        end

        vim.api.nvim_create_autocmd('User', {
            pattern = 'DapUIOpened',
            callback = function()
                -- Define keymaps in a table
                local dap_ui_keymaps = {
                    {
                        key = '<leader>q',
                        mode = 'n',
                        func = function()
                            require('dap').close()
                            require('dapui').close()
                        end,
                        desc = 'Quit Debugging (DAP UI)',
                    },
                    { key = '<leader>w', mode = 'n', func = '<C-w>q', desc = 'Close DAP UI Window' },
                    { key = '<leader>n', mode = 'n', func = require('dap').step_over, desc = 'Step Over (DAP UI)' },
                    { key = '<leader>i', mode = 'n', func = require('dap').step_into, desc = 'Step Into (DAP UI)' },
                    { key = '<leader>o', mode = 'n', func = require('dap').step_out, desc = 'Step Out (DAP UI)' },
                    { key = '<leader>c', mode = 'n', func = require('dap').continue, desc = 'Continue (DAP UI)' },
                    { key = '<leader>b', mode = 'n', func = require('dap').toggle_breakpoint, desc = 'Toggle Breakpoint (DAP UI)' },
                    { key = '<leader>B', mode = 'n', func = require('dap').set_breakpoint, desc = 'Set Conditional Breakpoint (DAP UI)' },
                    { key = '<leader>r', mode = 'n', func = require('dap').run_to_cursor, desc = 'Run to Cursor (DAP UI)' },
                    { key = '<leader>e', mode = { 'n', 'v' }, func = require('dapui').eval, desc = 'Evaluate (DAP UI)' },
                    {
                        key = '<esc>',
                        mode = 'n',
                        func = function()
                            local wins = vim.api.nvim_list_wins()
                            for _, w in ipairs(wins) do
                                local buf = vim.api.nvim_win_get_buf(w)
                                local filetype = vim.api.nvim_get_option_value('filetype', { buf = buf })
                                if
                                    filetype == 'dapui_scopes'
                                    or filetype == 'dapui_stacks'
                                    or filetype == 'dapui_watches'
                                    or filetype == 'dapui_breakpoints'
                                then
                                    vim.api.nvim_win_close(w, true)
                                end
                            end
                        end,
                        desc = 'Close DAP UI Window',
                        noremap = true,
                        silent = true,
                    },
                }

                -- Set DAP UI keymaps
                for _, map_data in ipairs(dap_ui_keymaps) do
                    set_dap_ui_keymap(map_data)
                end
            end,
        })

        vim.api.nvim_create_autocmd('User', {
            pattern = 'DapUIClosed',
            callback = function()
                -- Restore which-key mappings and remove DAP UI keymaps. Do for all modes where whichkey could be.
                for _, mode in ipairs { 'n', 'v', 'x', 'o' } do --All modes where which-key could be present
                    restore_dap_ui_keymaps(mode)
                end
            end,
        })

        -- WhichKey Integration: Save mappings *after* which-key sets them up
        vim.api.nvim_create_autocmd('User', {
            pattern = 'which_key_on_config_setup',
            callback = function()
                if not require('dapui').is_open() then
                    return
                end

                for _, mode in ipairs { 'n', 'v', 'x', 'o' } do --All modes where which-key could be present
                    original_leader_mappings[mode] = get_all_leader_mappings(mode)
                end
            end,
        })

        -- WhichKey Integration (optional, for extra safety): Restore mappings *before* which-key resets
        vim.api.nvim_create_autocmd('User', {
            pattern = 'which_key_on_config_reset', --This autocommand could be fired on other cases.
            callback = function()
                if not require('dapui').is_open() then
                    return
                end

                for _, mode in ipairs { 'n', 'v', 'x', 'o' } do --All modes where which-key could be present
                    restore_dap_ui_keymaps(mode) --Restore before whichkey clean.
                end
            end,
        })
    end,
}
