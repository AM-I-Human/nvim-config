-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank() --{ higroup = "Search", timeout = 100 }
    end,
})

-- vim.api.nvim_create_autocmd('VimEnter', {
--     desc = 'Auto open Nvim-tree on open',
--     group = vim.api.nvim_create_augroup('Nvim-tree-autoopen', { clear = true }),
--     callback = function()
--         require('nvim-tree.api').tree.open()
--     end,
-- })
