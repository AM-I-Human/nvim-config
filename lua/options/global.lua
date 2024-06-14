-- Set <space> as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.o.foldcolumn = '1' -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true
if IS_WINDOWS then
    vim.g.python3_host_prog = 'C:\\Users\\andre\\.pyenv\\pyenv-win\\versions\\nvim_3.12.3\\python.exe'
end
