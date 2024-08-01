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

-- local olama_pred_group = vim.api.nvim_create_augroup('OllamaPrediction', { clear = true })
-- vim.api.nvim_create_autocmd('TextChangedI', {
--     desc = 'Prediction with Ollama',
--     group = olama_pred_group,
--     callback = function()
--         local current_buffer = vim.api.nvim_get_current_buf()
--         local cursor_line_number = vim.api.nvim_win_get_cursor(0)[1] - 1
--         local cursor_col_number = vim.api.nvim_win_get_cursor(0)[2]
--
--         local nameme_space_id = vim.api.nvim_create_namespace 'demo'
--
--         local ollama_text = '<--' --require('ollama').prompt 'Fast virtual prediction'
--
--         -- print(ollama_text)
--
--         local opts = {
--             end_line = 10,
--             id = 1,
--             virt_text = { { ollama_text, 'IncSearch' } },
--             virt_text_pos = 'eol',
--         }
--
--         local mark_id = vim.api.nvim_buf_set_extmark(current_buffer, nameme_space_id, cursor_line_number, cursor_col_number, opts)
--     end,
-- })
--
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
