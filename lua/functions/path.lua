local M = {}
M.z_query = function(query)
    local path = vim.fn.trim(vim.fn.system('zoxide query ' .. query))
    return path
end

return M
