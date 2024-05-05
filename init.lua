require 'options.global'
require 'options.opt'
require 'commands.keymaps'

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

--[[ -- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
require('lazy').setup({
    'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
    --  This is equivalent to:
    --    require('Comment').setup({})

    -- require 'plugins.comments',
    -- require 'plugins.gitsings',
    -- require 'plugins.which-key',
    -- require 'plugins.telescope',
    -- require 'plugins.lsp',
    -- require 'plugins.conform',
    -- require 'plugins.nvim-cmp',
    -- require 'plugins.todo',
    -- require 'plugins.mini',
    -- require 'plugins.treesitter',
    -- require 'plugins.todo',
    -- require,

    -- require 'plugins.debug',
    -- require 'plugins.indent_line',
    -- require 'plugins.lint',
    -- require 'plugins.autopairs',
    -- require 'plugins.neo-tree',
    -- require 'plugins.gitsigns', -- adds gitsigns recommend keymaps

    --    For additional information, see `:help lazy.nvim-lazy.nvim-structuring-your-plugins`
    { import = 'plugins' },
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

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
