vim.api.nvim_create_user_command('Z', function(opts)
    local path = Path.z_query(opts.fargs[1])
    if vim.v.shell_error == 0 and path ~= '' then
        vim.cmd('silent! cd ' .. path)
        print('Changed directory to: ' .. path)
    else
        vim.api.nvim_err_writeln 'Zoxide: Directory not found'
    end
end, {
    nargs = 1,
    complete = 'shellcmd',
})
