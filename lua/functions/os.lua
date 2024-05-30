local M ={}
-- Function to detect the operating system
M.detect_os= function ()
    local uname = vim.loop.os_uname()
    if uname.sysname == 'Windows_NT' then
        return 'windows'
    elseif uname.sysname == 'Darwin' then
        return 'mac'
    else
        return 'linux'
    end
end

os = M.detect_os()
IS_MAC= 'mac'==os
IS_WINDOWS= 'windows'==os
IS_LINUX = 'linux'==os
return M
