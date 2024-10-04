local M = {}

M.install_comrak = function()
    if vim.fn.executable 'comrak' == 0 then
        print 'Installing comrak...'
        local install_cmd = 'cargo install comrak'
        local handle = io.popen(install_cmd)
        if handle then
            local result = handle:read '*a'
            handle:close()
            print(result)
        else
            print 'No result on stout, check if comrak was successuffly installed'
        end
    else
        print 'comrak is already installed'
    end
end
M.mason_post_install = function(pkg)
    M.install_comrak()
end

return M
