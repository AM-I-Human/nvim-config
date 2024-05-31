local M = {}
-- Function to detect the operating system
M.detect_os = function()
    local uname = vim.loop.os_uname()
    if uname.sysname == 'Windows_NT' then
        return 'windows'
    elseif uname.sysname == 'Darwin' then
        return 'mac'
    else
        return 'linux'
    end
end

CURRENT_OS = M.detect_os()
IS_MAC = 'mac' == CURRENT_OS
IS_WINDOWS = 'windows' == CURRENT_OS
IS_LINUX = 'linux' == CURRENT_OS
return M
