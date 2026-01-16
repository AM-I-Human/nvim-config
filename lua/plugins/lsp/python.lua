-- (The python.lua file from the previous response, with the IS_WINDOWS fix)
local M = {}

-- Function to install extra Python packages (using the global IS_WINDOWS)
local function install_python_packages(pkg, packages)
    if pkg.name ~= 'pyright' and pkg.name ~= 'python-lsp-server' then -- Run for pyright
        return
    end

    local venv_path = pkg:get_install_path() .. '/venv'
    local pip_path

    -- Use the existing IS_WINDOWS variable (defined elsewhere)
    if IS_WINDOWS then
        pip_path = venv_path .. '/Scripts/pip'
    else
        pip_path = venv_path .. '/bin/pip'
    end

    if not vim.loop.fs_stat(pip_path) then
        print('Could not find pip at: ' .. pip_path)
        return
    end

    local args = {
        'install',
        '-U',
        '--disable-pip-version-check',
    }
    vim.list_extend(args, packages)

    local job = require 'plenary.job'
    job:new({
        command = pip_path,
        args = args,
        cwd = venv_path,
        env = { VIRTUAL_ENV = venv_path },
        on_exit = function()
            vim.notify('Finished installing Python packages for ' .. pkg.name .. '.')
        end,
        on_start = function()
            vim.notify('Installing Python packages for ' .. pkg.name .. '...')
        end,
    }):start()
end

-- Post-install hook for Mason (to install mypy, etc.)
M.mason_post_install = function(pkg)
    install_python_packages(pkg, { 'mypy', 'ruff' }) 
end

-- Python-specific LSP setup (for pyright or pylance)
function M.setup()
    return {
        -- Configuration for pyright (if you choose to use it)
        settings = {
            python = {
                analysis = {
                    typeCheckingMode = 'basic', -- or "strict"
                    diagnosticMode = 'openFilesOnly',
                },
            },
        },

        -- Configuration for pylance (if you choose to use it instead of pyright)
        -- settings = {
        --   python = {
        --     analysis = {
        --       typeCheckingMode = "basic", -- or "strict"
        --       autoImportCompletions = true,
        --     }
        --   }
        -- },
    }
end

return M
