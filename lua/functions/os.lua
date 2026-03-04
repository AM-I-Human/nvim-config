local M = {}

-- Function to detect the operating system
M.detect_os = function()
    -- vim.uv è il nuovo standard su Neovim >= 0.10, vim.loop è il vecchio
    local uname = vim.uv and vim.uv.os_uname() or vim.loop.os_uname()

    if uname.sysname == 'Windows_NT' then
        return 'windows'
    elseif uname.sysname == 'Darwin' then
        return 'mac'
    else
        -- Siamo su Linux, ma verifichiamo se è WSL controllando la release del kernel
        local is_wsl = uname.release:lower():find 'microsoft' ~= nil or uname.release:lower():find 'wsl' ~= nil

        if is_wsl then
            return 'wsl'
        else
            return 'linux'
        end
    end
end

CURRENT_OS = M.detect_os()

IS_MAC = CURRENT_OS == 'mac'
IS_WINDOWS = CURRENT_OS == 'windows'
IS_WSL = CURRENT_OS == 'wsl'
IS_LINUX = CURRENT_OS == 'linux' or CURRENT_OS == 'wsl'

return M
