local M = {}

local find_file = function(filename)
    local opts_d = { stop = vim.loop.cwd(), type = 'file' }
    local opts_u = vim.tbl_extend('force', opts_d, { upward = true })

    return vim.fs.find(filename, opts_d)[1] or vim.fs.find(filename, opts_u)[1]
end
--
--local black_args_from_pyproject = function()
--    -- Make sure we have the treesitter parser for TOML.
--    require 'nvim-treesitter'
--
--    local args = {}
--    local config_file = find_file 'pyproject.toml'
--
--    if config_file == nil or vim.loop.fs_stat(config_file) == nil then
--        return args
--    end
--
--    local lines = {}
--    for line in io.lines(config_file) do
--        lines[#lines + 1] = line
--    end
--
--    local query = vim.treesitter.query.parse(
--        'toml',
--        [[
--            (table
--              (dotted_key) @dotkey (#eq? @dotkey "tool.black")
--              (pair
--                (bare_key) @barekey (#eq? @barekey "line-length")
--                (integer) @length
--              )
--            )
--        ]]
--    )
--
--    local config_buffer = vim.api.nvim_create_buf(false, true)
--
--    vim.api.nvim_buf_set_lines(config_buffer, 0, -1, false, lines)
--
--    local root = vim.treesitter.get_parser(config_buffer, 'toml', {}):parse()[1]:root()
--
--    for id, node in query:iter_captures(root, config_buffer, 0, -1) do
--        if query.captures[id] == 'length' then
--            table.insert(args, '--line-length')
--            table.insert(args, vim.treesitter.get_node_text(node, config_buffer))
--        end
--    end
--
--    vim.api.nvim_buf_delete(config_buffer, {})
--
--    return args
--end
--
--local black_args_from_build_gradle = function()
--    local args = {}
--    local config_file = find_file 'build.gradle'
--
--    if config_file == nil or vim.loop.fs_stat(config_file) == nil then
--        return args
--    end
--
--    local matches = {
--        ['lineLength'] = '--line-length',
--    }
--
--    for line in io.lines(config_file) do
--        for pattern, arg in pairs(matches) do
--            if line:match(pattern) then
--                table.insert(args, arg)
--                table.insert(args, line:match '%s+(%d+)')
--            end
--        end
--    end
--
--    return args
--end
--
---- Extract arguments to pass to blackd/blackd-client
----
---- Check build.gradle (work) and pyproject.toml.
--M.black_args = function()
--    return black_args_from_pyproject() or black_args_from_build_gradle() or {}
--end
--
-- null-ls formatter to use blackd-client if it exists.
M.blackd = function()
    local null_ls = require 'null-ls'
    local helpers = require 'null-ls.helpers'

    --
    if vim.fn.executable 'blackd-client' == 0 then
        print "blackd-client isn't available. Install it via mason.nvim"
        return nil
    end

    return helpers.make_builtin {
        name = 'blackd',
        method = null_ls.methods.FORMATTING,
        filetypes = { 'python' },
        generator_opts = {
            command = 'blackd-client',
            to_stdin = true,
        },
        factory = helpers.formatter_factory,
    }
end

-- Extract flake8 arguments from setup.cfg to pass to ruff.
--
-- The INI treesitter parser can't handle Python's setup.cfg file unfortunately.
M.ruff_args = function()
    local args = {}
    local config_file = find_file 'setup.cfg'

    if config_file == nil or vim.loop.fs_stat(config_file) == nil then
        return args
    end

    local matches = {
        ['^max%-line%-length'] = '--line-length=',
        ['^ignore%s*='] = '--ignore=',
        ['^extend%-ignore%s*='] = '--extend-ignore=',
    }

    for line in io.lines(config_file) do
        for pattern, arg in pairs(matches) do
            if line:match(pattern) then
                table.insert(args, arg .. line:match '%s*=%s*(.*)')
            end
        end
    end

    return args
end

-- Automate the installation of pylsp modules in it's virtualenv.
M.mason_post_install = function(pkg)
    if pkg.name ~= 'python-lsp-server' then
        return
    end

    local venv = vim.fn.stdpath 'data' .. '/mason/packages/python-lsp-server/venv'
    local job = require 'plenary.job'

    local pip_path = venv .. '/bin/pip'
    if IS_WINDOWS then
        pip_path = venv .. '/Scripts/pip'
    end
    job:new({
        command = pip_path,
        args = {
            'install',
            '-U',
            '--disable-pip-version-check',
            'pylsp-mypy',
            'pylsp-rope',
            'python-lsp-ruff',
            'ruff',
        },
        cwd = venv,
        env = { VIRTUAL_ENV = venv },
        on_exit = function()
            vim.notify 'Finished installing pylsp modules.'
        end,
        on_start = function()
            vim.notify 'Installing pylsp modules...'
        end,
    }):start()
end

-- Config for pylsp-ruff as a Lua table.
M.ruff_config = function()
    local config = {}
    local config_file = find_file 'setup.cfg'
    local pyproject = find_file 'pyproject.toml'

    if pyproject ~= nil then
        config['config'] = pyproject
    elseif config_file ~= nil and vim.loop.fs_stat(config_file) ~= nil then
        local matches = {
            ['^max%-line%-length'] = 'lineLength',
            ['^ignore%s*='] = 'ignore',
            ['^extend%-ignore%s*='] = 'extendIgnore',
        }

        for line in io.lines(config_file) do
            for pattern, key in pairs(matches) do
                if line:match(pattern) then
                    config[key] = line:match '%s*=%s*(.*)'
                end
            end
        end
    end

    return config
end

return M
