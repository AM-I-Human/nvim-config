-- [[ Setting options ]]
--
-- See `:help vim.opt`
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
vim.opt.clipboard = 'unnamedplus'

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 200

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 100
vim.opt.hlsearch = true

vim.opt.laststatus = 3

if IS_WINDOWS then
    vim.opt.shell = 'pwsh.exe -NoLogo'
    vim.opt.shellcmdflag =
        '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
    vim.api.nvim_set_option_value('shellredir', '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode', { scope = 'global' })
    vim.api.nvim_set_option_value('shellpipe', '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode', { scope = 'global' })
    vim.opt.shellquote = ''
    vim.opt.shellxquote = ''
elseif IS_MAC then
    vim.opt.shell = '/bin/zsh'
else
    vim.opt.shell = '/bin/bash'
end
