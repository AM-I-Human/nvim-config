local opts = {
    mode = 'n', -- NORMAL mode
    prefix = '<leader>',
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = true, -- use `nowait` when creating keymaps
}
local vopts = {
    mode = 'v', -- VISUAL mode
    prefix = '<leader>',
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = true, -- use `nowait` when creating keymaps
}
local mappings = {
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
}

return { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    config = function() -- This is the function that runs, AFTER loading
        local which_key = require('which-key').setup()

        -- Document existing key chains
        require('which-key').register {
            ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
            ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
            ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
            ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
            ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
            ['<leader>t'] = { name = '[T]oggle', _ = 'which_key_ignore' },
            ['<leader>h'] = { name = 'Git [H]unk', _ = 'which_key_ignore' },
        }
        -- visual mode
        require('which-key').register({
            ['<leader>gh'] = { 'Git [H]unk' },
        }, { mode = 'v' })

        require('which-key').register(mappings, opts)
        require('which-key').register(vmappings, vopts)
    end,
}
