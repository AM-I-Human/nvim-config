-- Set <space> as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true
if IS_WINDOWS then
    vim.g.python3_host_prog = 'C:\\Users\\andre\\.pyenv\\pyenv-win\\versions\\nvim_3.12.3\\python.exe'
end
