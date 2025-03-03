local M = {}
local Terminal = require('toggleterm.terminal').Terminal
local lazygit = Terminal:new {
    cmd = 'lazygit',
    hidden = true,
    direction = 'float',
    float_opts = { border = 'none', width = 100000, height = 100000 },
}

function _lazygit_toggle()
    lazygit:toggle()
end

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
        ['<A-j>'] = '<Esc>:m .+1<CR>==gi',
        ['<A-k>'] = '<Esc>:m .-2<CR>==gi',
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
        ['<C-h>'] = '<C-w>h',
        ['<C-j>'] = '<C-w>j',
        ['<C-k>'] = '<C-w>k',
        ['<C-l>'] = '<C-w>l',
        ['<C-Up>'] = ':resize -3<CR>',
        ['<C-Down>'] = ':resize +3<CR>',
        ['<C-Left>'] = ':vertical resize -3<CR>',
        ['<C-Right>'] = ':vertical resize +3<CR>',
        ['<A-j>'] = ':m .+1<CR>==',
        ['<A-k>'] = ':m .-2<CR>==',
        [']q'] = ':cnext<CR>',
        ['[q'] = ':cprev<CR>',
        ['<A-H>'] = { ':bprevious<CR>', 'Previous buffer' },
        ['<A-L>'] = { ':bnext<CR>', 'Next buffer' },
        ['<Esc>'] = '<cmd>nohlsearch<CR>',
        g = {
            d = { require('telescope.builtin').lsp_definitions, 'Definition' },
            D = { vim.lsp.buf.declaration, 'Declaration' },
            r = { require('telescope.builtin').lsp_references, 'References' },
            I = { require('telescope.builtin').lsp_implementations, 'Implementation' },
        },
        K = { vim.lsp.buf.hover, 'Hover Documentation' },
    },

    term_mode = {
        ['<C-h>'] = '<C-\\><C-N><C-w>h',
        ['<C-j>'] = '<C-\\><C-N><C-w>j',
        ['<C-k>'] = '<C-\\><C-N><C-w>k',
        ['<C-l>'] = '<C-\\><C-N><C-w>l',
    },

    visual_mode = {
        ['<'] = '<gv',
        ['>'] = '>gv',
        -- Keymap for range code action in visual mode
    },

    visual_block_mode = {
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
            f = { vim.lsp.buf.format, 'Format' },
            -- require('conform').format { async = true, lsp_fallback = true }
        },
        e = {
            function()
                require('oil').toggle_float(nil)
                require('oil').open_preview { vertical = true, split = 'botright' }
            end,
            'Explorer',
        },
        F = {
            name = 'Flutter',
            a = { require('flutter-tools.commands').attach, 'Attach' },
            y = { require('flutter-tools.commands').copy_profiler_url, 'CopyProfilerUrl' },
            d = { require('flutter-tools.devices').list_devices, 'Devices' },
            D = { require('flutter-tools.commands').detach, 'Detach' },
            t = { require('flutter-tools.dev_tools').start, 'DevTools' },
            T = { require('flutter-tools.dev_tools').activate, 'DevToolsActivate' },
            E = { require('flutter-tools.devices').list_emulators, 'Emulators' },
            l = { require('flutter-tools.log').toggle, 'LogToggle' },
            L = { require('flutter-tools.log').clear, 'LogClear' },
            o = { require('flutter-tools.outline').toggle, 'OutlineToggle' },
            O = { require('flutter-tools.outline').open, 'OutlineOpen' },
            q = { require('flutter-tools.commands').quit, 'Quit' },
            re = { require('flutter-tools.commands').reload, 'Reload' },
            r = { '<cmd>FlutterRun<cr>', 'Run' },
            rd = { '<cmd>FlutterDebug<cr>', 'Debug' },
            R = { require('flutter-tools.commands').restart, 'Restart' },
            S = { require('flutter-tools.lsp').dart_lsp_super, 'Super' },
        },
        g = {
            name = 'Git',
            g = { _lazygit_toggle, 'Lazygit' },
            L = { name = 'Lab', m = { require('gitlab').choose_merge_request, 'Choose merge request' } },
            j = { require('gitsigns').nav_hunk 'next', 'Next Hunk' },
            k = { require('gitsigns').nav_hunk 'prev', 'Previous Hunk' },
            l = { require('gitsigns').blame_line, 'Blame' },
            p = { require('gitsigns').preview_hunk, 'Preview Hunk' },
            r = { require('gitsigns').reset_hunk, 'Reset Hunk' },
            R = { require('gitsigns').reset_buffer, 'Reset Buffer' },
            s = { require('gitsigns').stage_hunk, 'Stage Hunk' },
            u = { require('gitsigns').stage_hunk, 'Undo Stage Hunk' },
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
                u = {
                    name = 'UV run',
                    function()
                        require('dap').continue { config = 'UV run' }
                    end,
                    'Debug with uv run',
                },
            },
            b = { require('dap').toggle_breakpoint, 'Toggle Breakpoint' },
            r = { name = 'Run', b = { require('dap').run_to_cursor, 'Run To Cursor' } },
            e = { require('dapui').eval, 'Evaluate' },
            q = {
                function()
                    require('dap').close()
                    require('dapui').close()
                end,
                'Quit Debugging',
            },
            ['?'] = {
                function()
                    require('dapui').eval(vim.fn.expand '<cexpr>')
                end,
                'Evaluate under cursor',
            },

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
            t = { require('telescope.builtin').lsp_type_definitions, 'Type Definition' },
            g = { require('telescope.builtin').live_grep, 'Grep' },
            h = { require('telescope.builtin').help_tags, 'Help' },
            k = { require('telescope.builtin').keymaps, 'Keymaps' },
            r = { require('telescope.builtin').oldfiles, 'Recent Files ("." for repeat)' },
            t = { require('telescope.builtin').builtin, 'Search Types Telescope' },
            w = { require('telescope.builtin').grep_string, 'current Word' },
            ['.'] = { require('telescope.builtin').resume, 'Resume' },
            ['/'] = {
                function()
                    require('telescope.builtin').live_grep {
                        grep_open_files = true,
                        prompt_title = 'Live Grep in Open Files',
                    }
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
                    local client = vim.lsp.get_clients()[1]
                    if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
                        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
                    end
                end,
                '[T]oggle Inlay [H]ints',
            },
        },
    },
    visual_mode = {
        c = {
            r = { vim.lsp.buf.rename, 'Rename' },
            a = {
                vim.lsp.buf.range_code_action,
                'Action',
            },
            f = { vim.lsp.buf.format, 'Format' },
        },
    },
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
