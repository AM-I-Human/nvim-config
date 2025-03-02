-- Set <space> as the leader key
local font = 'OperatorMono Nerd Font'
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

vim.o.foldcolumn = '1' -- '0' is not bad
vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

if vim.g.neovide then
    vim.o.guifont = font .. ':h10'
end

if IS_WINDOWS then
    vim.g.python3_host_prog = 'C:\\Users\\andre\\.pyenv\\pyenv-win\\versions\\nvim_3.12.3\\python.exe'
end
