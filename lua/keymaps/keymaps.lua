local M = {}

-- insert_mode = 'i',
-- normal_mode = 'n',
-- term_mode = 't',
-- visual_mode = 'v',
-- visual_block_mode = 'x',
-- command_mode = 'c',
-- operator_pending_mode = 'o',
-- select_mode = 's'

---@class Keys
---@field insert_mode table
---@field normal_mode table
---@field terminal_mode table
---@field visual_mode table
---@field visual_block_mode table
---@field command_mode table
---@field operator_pending_mode table
M.nvim_mappings = {
    insert_mode = {
        -- Move current line / block with Alt-j/k ala vscode.
        ['<A-j>'] = '<Esc>:m .+1<CR>==gi',
        -- Move current line / block with Alt-j/k ala vscode.
        ['<A-k>'] = '<Esc>:m .-2<CR>==gi',
        -- navigation
        ['<A-Up>'] = '<C-\\><C-N><C-w>k',
        ['<A-Down>'] = '<C-\\><C-N><C-w>j',
        ['<A-Left>'] = '<C-\\><C-N><C-w>h',
        ['<A-Right>'] = '<C-\\><C-N><C-w>l',
        ['<c-k>'] = {
            function()
                local luasnip = require 'luasnip'
                if luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                end
            end,
            'Next template argument jump',
        },
        ['<c-l>'] = {
            function()
                local luasnip = require 'luasnip'
                if luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                end
            end,
            'Previous template argument jump',
        },
    },

    normal_mode = {
        -- Better window movement
        ['<C-h>'] = '<C-w>h',
        ['<C-j>'] = '<C-w>j',
        ['<C-k>'] = '<C-w>k',
        ['<C-l>'] = '<C-w>l',

        -- Resize with arrows
        ['<C-Up>'] = ':resize -3<CR>',
        ['<C-Down>'] = ':resize +3<CR>',
        ['<C-Left>'] = ':vertical resize -3<CR>',
        ['<C-Right>'] = ':vertical resize +3<CR>',

        -- Move current line / block with Alt-j/k a la vscode.
        ['<A-j>'] = ':m .+1<CR>==',
        ['<A-k>'] = ':m .-2<CR>==',

        -- QuickFix
        [']q'] = ':cnext<CR>',
        ['[q'] = ':cprev<CR>',
        ['<A-H>'] = {
            ':bprevious<CR>',
            'Previous buffer',
        },
        ['<A-L>'] = {
            ':bnext<CR>',
            'Next buffer',
        },

        -- Set highlight on search, but clear on pressing <Esc> in normal mode
        ['<Esc>'] = '<cmd>nohlsearch<CR>',
        g = {
            d = { require('telescope.builtin').lsp_definitions, 'Definition' },
            D = { vim.lsp.buf.declaration, 'Declaration' },
            r = { require('telescope.builtin').lsp_references, 'References' },
            I = { require('telescope.builtin').lsp_implementations, 'Implementation' },
            t = { require('telescope.builtin').lsp_type_definitions, 'Type Definition' },
        },
        K = { vim.lsp.buf.hover, 'Hover Documentation' },
    },

    term_mode = {
        -- Terminal window navigation
        ['<C-h>'] = '<C-\\><C-N><C-w>h',
        ['<C-j>'] = '<C-\\><C-N><C-w>j',
        ['<C-k>'] = '<C-\\><C-N><C-w>k',
        ['<C-l>'] = '<C-\\><C-N><C-w>l',
    },

    visual_mode = {
        -- Better indenting
        ['<'] = '<gv',
        ['>'] = '>gv',

        -- ["p"] = '"0p',
        -- ["P"] = '"0P',
    },

    visual_block_mode = {
        -- Move current line / block with Alt-j/k ala vscode.
        ['<A-j>'] = ":m '>+1<CR>gv-gv",
        ['<A-k>'] = ":m '<-2<CR>gv-gv",
        ['<C-j>'] = {
            function()
                require('flash').jump()
            end,
            { desc = 'Jump' },
        },
        ['<C-J>'] = {
            function()
                require('flash').treesitter()
            end,
            { desc = 'Semantic Jump' },
        },
        R = {
            function()
                require('flash').treesitter_search()
            end,
            { desc = 'Treesitter Search' },
        },
    },

    select_mode = {

        ['<c-k>'] = {
            function()
                local luasnip = require 'luasnip'
                if luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                end
            end,
            'Next template argument jump',
        },
        ['<c-l>'] = {
            function()
                local luasnip = require 'luasnip'
                if luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                end
            end,
            'Previous template argument jump',
        },
    },

    command_mode = {
        ['<C-j>'] = {
            function()
                require('flash').toggle()
            end,
            { desc = 'Toggle Flash Search' },
        },
    },

    operator_pending_mode = {
        r = {
            function()
                require('flash').remote()
            end,
            { desc = 'Remote Flash' },
        },
        R = {
            function()
                require('flash').treesitter_search()
            end,
            { desc = 'Treesitter Search' },
        },
    },
}

-- Fuzzy find all the symbols in your current document.
--  Symbols are things like variables, functions, types, etc.
-- map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
--
-- -- Fuzzy find all the symbols in your current workspace.
-- --  Similar to document symbols, except searches over your entire project.
-- map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
--
-- map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

---@class WhichKeyKeys
---@field insert_mode table
---@field normal_mode table
---@field terminal_mode table
---@field visual_mode table
---@field visual_block_mode table
---@field command_mode table
---@field operator_pending_mode table
---@field pages table
local leader_keymaps = {
    normal_mode = {
        c = {
            r = { vim.lsp.buf.rename, 'Rename' },
            a = { vim.lsp.buf.code_action, 'Action' },
            f = { vim.lsp.buf.format, 'Format' }, -- new keymap for formatting

            -- " simple code action for normal mode and visual mode
            -- nmap <buffer> <Leader><Leader> <plug>(lsp-code-action)
            -- vmap <buffer> <Leader><Leader> :LspCodeAction<CR>
            --
            -- " alternative that uses floating window
            -- " nmap <buffer> <Leader>f <plug>(lsp-code-action-float)
            --
            -- " mapping for filtered code actions
            -- nmap <buffer> <Leader>ri :LspCodeAction refactor.inline<CR>
            -- nmap <buffer> <Leader>ro :LspCodeAction source.organizeImports<CR>
            -- vmap <buffer> <Leader>rm :LspCodeAction refactor.extract<CR>
            -- nmap <buffer> <Leader>rm :LspCodeAction refactor.extract<CR>
        },
        -- E = {
        --     name = 'Explorer Functions',
        --     p = { require('nvim-tree.api').tree.change_root_to_parent, 'Root To Parent' },
        --     ['?'] = { require('nvim-tree.api').tree.toggle_help, 'Help' },
        -- },
        e = {
            function()
                require('oil').toggle_float(nil)
                require('oil').open_preview { vertical = true, split = 'botright' }
            end,
            'Explorer',
        },
        F = {
            name = 'Flutter',
            a = { require('flutter-tools.commands').attach, 'Attach' }, -- Attach to a running app.
            y = { require('flutter-tools.commands').copy_profiler_url, 'CopyProfilerUrl' }, -- Copies the profiler url to your system clipboard (+ register). Note that commands FlutterRun and FlutterDevTools must be executed first.
            d = { require('flutter-tools.devices').list_devices, 'Devices' }, -- Brings up a list of connected devices to select from.
            D = { require('flutter-tools.commands').detach, 'Detach' }, -- Ends a running session locally but keeps the process running on the device.
            t = { require('flutter-tools.dev_tools').start, 'DevTools' }, -- Starts a Dart Dev Tools server.
            T = { require('flutter-tools.dev_tools').activate, 'DevToolsActivate' }, -- Activates a Dart Dev Tools server.
            E = { require('flutter-tools.devices').list_emulators, 'Emulators' }, -- Similar to devices but shows a list of emulators to choose from.
            l = { require('flutter-tools.log').toggle, 'LogToggle' }, -- Toggles the log buffer.
            L = { require('flutter-tools.log').clear, 'LogClear' }, -- Clears the log buffer.
            o = { require('flutter-tools.outline').toggle, 'OutlineToggle' }, -- Toggle the outline window showing the widget tree for the given file.
            O = { require('flutter-tools.outline').open, 'OutlineOpen' }, -- Opens an outline window showing the widget tree for the given file.
            q = { require('flutter-tools.commands').quit, 'Quit' }, -- Ends a running session.
            re = { require('flutter-tools.commands').reload, 'Reload' }, -- Reload the running project.
            r = { '<cmd>FlutterRun<cr>', 'Run' }, -- Run the current project. Respects config.debugger.enabled setting.
            rd = { '<cmd>FlutterDebug<cr>', 'Debug' }, -- Force run current project in debug mode.
            R = { require('flutter-tools.commands').restart, 'Restart' }, -- Restart the current project.
            S = { require('flutter-tools.lsp').dart_lsp_super, 'Super' }, -- Go to super class, method using custom LSP method dart/textDocument/super.
            -- defining all Flutter.nvim leader keymaps for the commands
        },
        g = {
            name = 'Git',
            g = { require('plugins.terminal').lazygit_toggle(), 'Lazygit' },
            j = { require('gitsigns').nav_hunk 'next', 'Next Hunk' },
            k = { require('gitsigns').nav_hunk 'prev', 'Previous Hunk' },
            l = { require('gitsigns').blame_line(), 'Blame' },
            p = { require('gitsigns').preview_hunk(), 'Preview Hunk' },
            r = { require('gitsigns').reset_hunk(), 'Reset Hunk' },
            R = { require('gitsigns').reset_buffer(), 'Reset Buffer' },
            s = { require('gitsigns').stage_hunk(), 'Stage Hunk' },
            u = { require('gitsigns').undo_stage_hunk(), 'Undo Stage Hunk' },
            o = { '<cmd>Telescope git_status<cr>', 'Open changed file' },
            b = { '<cmd>Telescope git_branches<cr>', 'Checkout branch' },
            c = { '<cmd>Telescope git_commits<cr>', 'Checkout commit' },
            C = { '<cmd>Telescope git_bcommits<cr>', 'Checkout commit(for current file)' },
            d = { '<cmd>Gitsigns diffthis HEAD<cr>', 'Git Diff' },
        },
        j = {
            name = 'Jump',
            j = {
                function()
                    require('flash').jump()
                end,
                'Jump',
            },
            J = {
                function()
                    require('flash').treesitter()
                end,
                'Semantic Jump',
            },
            r = {
                function()
                    require('flash').remote()
                end,
                'Remote Flash',
            },
            R = {
                function()
                    require('flash').treesitter_search()
                end,
                'Treesitter Search',
            },
            t = {
                function()
                    require('flash').toggle()
                end,
                'Toggle Flash Search',
            },
        },

        D = {
            name = 'DAP',
            P = {
                name = 'Python',
                t = { require('dap-python').test_method, 'Test Method' },
            },
            b = { require('dap').toggle_breakpoint, 'Toggle Breakpoint' },

            r = { name = 'Run', b = { require('dap').run_to_cursor, 'Run To Cursor' } },
            e = { require('dapui').eval, 'Evaluate' },
            ['0'] = { require('dap').restart, 'Restart' },
            ['1'] = { require('dap').continue, 'Continue' },
            ['2'] = { require('dap').step_into, 'Step Into' },
            ['3'] = { require('dap').step_over, 'Step Over' },
            ['4'] = { require('dap').step_out, 'Step Out' },
            ['5'] = { require('dap').step_back, 'Step Back' },
        },
        G = {
            G = { ':Gen<CR>', 'Gen Options' },
            s = { ':Gen Enhance_Grammar_Spelling<CR>', 'Spelling' },
            c = { ':Gen Chat<CR>', 'Chat' },
            a = { ':Gen Ask<CR>', 'Ask' },
        },
        O = {
            name = 'OIL',
            o = {
                function()
                    require('oil').open()
                end,
                'Open Oil',
            },
            q = {
                function()
                    require('oil').close()
                end,
                'Close Oil',
            },
            v = {
                function()
                    require('oil').open_float()
                end,
                'Open Oil in Float',
            },
            h = {
                function()
                    require('oil').toggle_hidden()
                end,
                'Toggle Hidden Files',
            },
            r = {
                function()
                    require('oil').refresh()
                end,
                'Refresh Oil',
            },
            s = {
                function()
                    require('oil').select()
                end,
                'Select File/Directory',
            },
            d = {
                function()
                    require('oil').cd()
                end,
                'Change Directory',
            },
            p = {
                function()
                    require('oil').open_cwd()
                end,
                'Open CWD',
            },
        },
        P = { name = 'Python', v = { '<cmd>VenvSelect<cr>', 'Select Environment' } },
        s = {
            name = 'Search',
            b = { require('telescope.builtin').buffers, 'Find existing buffers' },
            d = { require('telescope.builtin').diagnostics, 'Diagnostics' },
            F = { '<cmd>Telescope file_browser<CR>', 'File Browser' },
            f = {
                function()
                    require('telescope.builtin').find_files { hidden = true }
                end,
                'Files',
            },
            g = { require('telescope.builtin').live_grep, 'Grep' },
            h = { require('telescope.builtin').help_tags, 'Help' },
            k = { require('telescope.builtin').keymaps, 'Keymaps' },
            r = { require('telescope.builtin').oldfiles, 'Recent Files ("." for repeat)' },
            t = { require('telescope.builtin').builtin, 'Search Types Telescope' },
            w = { require('telescope.builtin').grep_string, 'current Word' },
            ['.'] = { require('telescope.builtin').resume, 'Resume' },
            ['/'] = {
                function()
                    require('telescope.builtin').live_grep { grep_open_files = true, prompt_title = 'Live Grep in Open Files' }
                end,
                '/ in Open Files',
            },
            n = {
                function()
                    require('telescope.builtin').find_files { cwd = vim.fn.stdpath 'config' }
                end,
                'Neovim files',
            },
        },
        t = {
            h = {
                function()
                    if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
                        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
                    end
                end,
                '[T]oggle Inlay [H]ints',
            },
        },
    },

    -- Shortcut for searching your Neovim configuration files
    visual_mode = {
        c = {
            r = { vim.lsp.buf.rename, 'Rename' },
            a = { vim.lsp.buf.range_code_action, 'Action' }, -- new keymap for formatting
            f = { vim.lsp.buf.format, 'Format' }, -- new keymap for formatting
        },
    },
    -- See `:help telescope.builtin`

    ---@class WhichKeyPages
    ---@field insert_mode table
    ---@field normal_mode table
    ---@field terminal_mode table
    ---@field visual_mode table
    ---@field visual_block_mode table
    ---@field command_mode table
    ---@field operator_pending_mode table
    pages = {
        normal_mode = {
            -- { '<leader>D', group = 'Debug' },
            { '<leader>P', group = 'Python' },
            { '<leader>c', group = 'Code' },
            { '<leader>d', group = 'DB' },
            { '<leader>h', group = 'Git Hunk' },
            { '<leader>r', group = 'Rename' },
            { '<leader>s', group = 'Search' },
            { '<leader>t', group = 'Toggle' },
            { '<leader>w', group = 'Workspace' },
        },
        visual_mode = {},
    },
}
M.which_key_mappings = leader_keymaps

return M
