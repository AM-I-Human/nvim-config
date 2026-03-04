-- Set <space> as the leader key
local font = 'OperatorMono Nerd Font'
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

vim.o.foldcolumn = '1' -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

if vim.g.neovide and IS_WINDOWS then
    vim.o.guifont = font .. ':h10'
end

if IS_WINDOWS then
    vim.g.python3_host_prog = 'C:\\Users\\andre\\.pyenv\\pyenv-win\\versions\\nvim_3.12.3\\python.exe'
    vim.o.shell = 'pwsh' -- or "powershell"
    vim.o.shellcmdflag =
        '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
    vim.o.shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
    vim.o.shellpipe = '2>&1 | Tee-Object %s; exit $LastExitCode'
    vim.o.shellquote = ''
    vim.o.shellxquote = ''
end

-- === CONFIGURAZIONE WSL ===
if IS_WSL then
    -- Costruiamo il path dinamicamente usando la HOME di Linux
    local home = os.getenv 'HOME'

    -- Punta all'ambiente 'nvim-env' creato con pyenv
    vim.g.python3_host_prog = home .. '/.pyenv/versions/3.13.11/envs/nvim-env-13/bin/python'

    -- (Opzionale) Se vuoi che la clipboard funzioni tra WSL e Windows (richiede win32yank.exe)
    vim.g.clipboard = {
        name = 'WslClipboard',
        copy = {
            ['+'] = 'clip.exe',
            ['*'] = 'clip.exe',
        },
        paste = {
            ['+'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
            ['*'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
        },
        cache_enabled = 0,
    }
end
