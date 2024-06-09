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
-- local excluded_filetypes = {
--     'unite',
--     'tagbar',
--     'startify',
--     'gundo',
--     'vimshell',
--     'w3m',
--     'nerdtree',
--     'Mundo',
--     'MundoDiff',
--     'alpha',
--     'NvimTree',
-- }
--
-- local relative_numbers = {
--     activate = {
--         'VimEnter',
--         'InsertLeave',
--         'WinEnter',
--         'FocusGained',
--     },
--     deactivate = {
--         'WinLeave',
--         'FocusLost',
--         'BufNewFile',
--         'BufReadPost',
--         'InsertEnter',
--     },
-- }
--
-- local group = vim.api.nvim_create_augroup('NumbersAutocmds', { clear = true })
--
-- vim.api.nvim_create_autocmd(relative_numbers.activate, {
--     desc = 'Set line numbers dinamically',
--     group = group,
--     callback = function()
--         local not_excluded = excluded_filetypes[vim.api.nvim_get_option_value('filetype', {})] == nil
--         -- vim.opt.number = not_excluded
--         vim.opt.relativenumber = not_excluded
--     end,
-- })
--
-- vim.api.nvim_create_autocmd(relative_numbers.deactivate, {
--     desc = 'Set line numbers dinamically',
--     group = group,
--     callback = function()
--         local not_excluded = excluded_filetypes[vim.api.nvim_get_option_value('filetype', {})] == nil
--         vim.opt.number = not_excluded
--         vim.opt.relativenumber = false
--     end,
-- })
