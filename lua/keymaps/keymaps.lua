---@class Keys
---@field insert_mode table
---@field normal_mode table
---@field terminal_mode table
---@field visual_mode table
---@field visual_block_mode table
---@field command_mode table
---@field operator_pending_mode table
local mappings = {
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

        -- Resize with arrows
        ['<C-Up>'] = ':resize -2<CR>',
        ['<C-Down>'] = ':resize +2<CR>',
        ['<C-Left>'] = ':vertical resize -3<CR>',
        ['<C-Right>'] = ':vertical resize +3<CR>',

        -- Move current line / block with Alt-j/k a la vscode.
        ['<A-j>'] = ':m .+1<CR>==',
        ['<A-k>'] = ':m .-2<CR>==',

        -- QuickFix
        [']q'] = ':cnext<CR>',
        ['[q'] = ':cprev<CR>',
        -- ["<C-q>"] = ":call QuickFixToggle()<CR>",

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

return mappings
