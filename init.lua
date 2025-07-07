if vim.loader then
    vim.loader.enable()
end

require 'functions.os'
require 'options.global'
require 'options.opt'
require 'options.mouse'

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
    { 'linrongbin16/commons.nvim', lazy = true },
    -- THIS IS YOUR LOCAL PLUGIN
    {
        dir = 'C:/Users/andre/Projects/Jove.nvim/',
        name = 'jove',
        dev = true,
        -- Define commands so lazy knows when to load/reload the plugin
        cmd = { 'JoveStart', 'JoveExecute' },
        -- Define keymaps directly here
        keys = {
            { '<Leader>Je', '<cmd>JoveExecute<cr>', mode = { 'n', 'x' }, desc = 'Jove: Execute line/selection' },
            { '<Leader>Js', '<cmd>JoveStart python<cr>', mode = { 'n' }, desc = 'Jove: Execute line/selection' },
        },
        config = function()
            -- This is the standard way to set up a plugin
            require('jove').setup {
                kernels = {
                    python = { cmd = 'python -m ipykernel_launcher -f {connection_file}' },
                    -- Aggiungi altri kernel se necessario
                },
            }

            -- You likely don't need this if your plugin structure is correct,
            -- as `setup()` should handle command creation.
            -- require 'jove.commands'
        end,
    },
    { import = 'plugins' },
    { import = 'plugins.jupyter' },
    { import = 'plugins.file' },
    { import = 'plugins.ai' },
    require 'plugins.lsp.java',
    { import = 'plugins.mobile' },
}, {
    ui = {
        -- If you are using a Nerd Font: set icons to an empty table which will use the
        -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
        icons = vim.g.have_nerd_font and {} or {
            cmd = '⌘',
            config = '🛠',
            event = '📅',
            ft = '📂',
            init = '⚙',
            keys = '🗝',
            plugin = '🔌',
            runtime = '💻',
            require = '🌙',
            source = '📄',
            start = '🚀',
            task = '📌',
            lazy = '💤 ',
        },
    },
})

require 'ui.sign'
require 'functions.autocommands'
require 'functions.reload'
require 'keymaps.load_keymaps'
