M = {}

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
    },

    normal_mode = {
        -- Better window movement
        ['<C-h>'] = '<C-w>h',
        ['<C-j>'] = '<C-w>j',
        ['<C-k>'] = '<C-w>k',
        ['<C-l>'] = '<C-w>l',

        ['C-H'] = ':bprevious',
        ['C-L'] = ':bnext',

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

        -- Set highlight on search, but clear on pressing <Esc> in normal mode
        ['<Esc>'] = '<cmd>nohlsearch<CR>',
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
    },
    command_mode = {
        -- navigate tab completion with <c-j> and <c-k>
        -- runs conditionally
        ['<C-j>'] = { 'pumvisible() ? "\\<C-n>" : "\\<C-j>"', { expr = true, noremap = true } },
        ['<C-k>'] = { 'pumvisible() ? "\\<C-p>" : "\\<C-k>"', { expr = true, noremap = true } },
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
M.which_key_mappings = {
    insert_mode = {

        ['e'] = { '<cmd>NvimTreeToggle<CR>', 'Explorer' },
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

        D = {
            name = 'DAP',
            P = {
                t = { require('dap-python').test_method, 'Test Method' },
            },
            b = { require('dap').toggle_breakpoint, 'Toggle Breakpoint' },

            r = { name = 'Run', b = { require('dap').run_to_cursor, 'Run To Cursor' } },
            e = { require('dapui').eval, 'Evaluate' },
        },
        D1 = { require('dap').continue, 'Continue' },
        D2 = { require('dap').step_into, 'Step Into' },
        D3 = { require('dap').step_over, 'Step Over' },
        D4 = { require('dap').step_out, 'Step Out' },
        D5 = { require('dap').step_back, 'Step Back' },
        D0 = { require('dap').restart, 'Restart' },
        P = { name = 'Python', v = { '<cmd>VenvSelect<cr>', 'Select Environment' } },
    },
    visual_mode = {},

    ---@class WhichKeyPages
    ---@field insert_mode table
    ---@field normal_mode table
    ---@field terminal_mode table
    ---@field visual_mode table
    ---@field visual_block_mode table
    ---@field command_mode table
    ---@field operator_pending_mode table
    pages = {
        insert_mode = {
            ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
            ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
            ['<leader>D'] = { name = '[D]ebug', _ = 'which_key_ignore' },
            ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
            ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
            ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
            ['<leader>t'] = { name = '[T]oggle', _ = 'which_key_ignore' },
            ['<leader>h'] = { name = 'Git [H]unk', _ = 'which_key_ignore' },
            ['<leader>P'] = { name = 'Python', _ = 'which_key_ignore' },
        },
        visual_mode = {},
    },
}

return M
