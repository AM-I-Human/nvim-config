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
        ['C-j'] = {
            function()
                require('flash').jump()
            end,
            { desc = 'Jump' },
        },
        ['C-J'] = {
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
        ['<C-j'] = {
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
        },
        E = {
            name = 'Explorer Functions',
            p = { require('nvim-tree.api').tree.change_root_to_parent, 'Root To Parent' },
            ['?'] = { require('nvim-tree.api').tree.toggle_help, 'Help' },
        },
        e = { '<cmd>NvimTreeToggle<CR>', 'Explorer' },
        f = { '<cmd>Telescope file_browser<CR>', 'File Browser' },
        g = {
            name = 'Git',
            g = { "<cmd>lua require 'plugins.terminal'.lazygit_toggle()<cr>", 'Lazygit' },
            j = { "<cmd>lua require 'gitsigns'.next_hunk({navigation_message = false})<cr>", 'Next Hunk' },
            k = { "<cmd>lua require 'gitsigns'.prev_hunk({navigation_message = false})<cr>", 'Prev Hunk' },
            l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", 'Blame' },
            p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", 'Preview Hunk' },
            r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", 'Reset Hunk' },
            R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", 'Reset Buffer' },
            s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", 'Stage Hunk' },
            u = {
                "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
                'Undo Stage Hunk',
            },
            o = { '<cmd>Telescope git_status<cr>', 'Open changed file' },
            b = { '<cmd>Telescope git_branches<cr>', 'Checkout branch' },
            c = { '<cmd>Telescope git_commits<cr>', 'Checkout commit' },
            C = {
                '<cmd>Telescope git_bcommits<cr>',
                'Checkout commit(for current file)',
            },
            d = {
                '<cmd>Gitsigns diffthis HEAD<cr>',
                'Git Diff',
            },
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
        P = { name = 'Python', v = { '<cmd>VenvSelect<cr>', 'Select Environment' } },
        s = {
            name = 'Search',
            h = { require('telescope.builtin').help_tags, 'Help' },
            k = { require('telescope.builtin').keymaps, 'Keymaps' },
            f = { require('telescope.builtin').find_files, 'Files' },
            s = { require('telescope.builtin').builtin, 'Search Types Telescope' },
            w = { require('telescope.builtin').grep_string, 'current Word' },
            g = { require('telescope.builtin').live_grep, 'Grep' },
            d = { require('telescope.builtin').diagnostics, 'Diagnostics' },
            r = { require('telescope.builtin').oldfiles, 'Recent Files ("." for repeat)' },
            b = { require('telescope.builtin').buffers, 'Find existing buffers' },
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
    visual_mode = {},

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
            ['<leader>c'] = { name = 'Code', _ = 'which_key_ignore' },
            ['<leader>d'] = { name = 'DB', _ = 'which_key_ignore' },
            ['<leader>D'] = { name = 'Debug', _ = 'which_key_ignore' },
            ['<leader>r'] = { name = 'Rename', _ = 'which_key_ignore' },
            ['<leader>s'] = { name = 'Search', _ = 'which_key_ignore' },
            ['<leader>w'] = { name = 'Workspace', _ = 'which_key_ignore' },
            ['<leader>t'] = { name = 'Toggle', _ = 'which_key_ignore' },
            ['<leader>h'] = { name = 'Git Hunk', _ = 'which_key_ignore' },
            ['<leader>P'] = { name = 'Python', _ = 'which_key_ignore' },
        },
        visual_mode = {},
    },
}
M.which_key_mappings = leader_keymaps

return M
