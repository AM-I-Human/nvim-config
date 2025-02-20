-- Molten.nvim configuration with Jupyter, Quarto, and Jupytext integration
return {
    'benlubas/molten-nvim',
    build = ':UpdateRemotePlugins',
    event = 'VeryLazy',
    priority = 10,

    dependencies = {
        'willothy/wezterm.nvim', -- For image rendering
        'quarto-dev/quarto-nvim', -- Quarto integration
        'goerz/jupytext.vim', -- Jupytext for converting between formats
    },

    -- Keybindings
    keys = {
        { '<leader>mi', ':MoltenInit<cr>', desc = '[m]olten [i]nit' },
        { '<leader>mv', ':<C-u>MoltenEvaluateVisual<cr>', mode = 'v', desc = 'molten eval visual' },
        { '<leader>mr', ':MoltenReevaluateCell<cr>', desc = 'molten re-eval cell' },
        { '<leader>md', ':MoltenDelete<cr>', desc = 'molten delete cell' },
        { '<leader>mh', ':MoltenHideOutput<cr>', desc = 'molten hide output' },
        { '<leader>ms', ':noautocmd w<cr>', desc = 'save without triggering auto-commands' },
    },

    -- Initial setup
    init = function()
        -- Output configuration
        vim.g.molten_auto_open_output = false -- Must be false when using wezterm
        vim.g.molten_output_show_more = true
        vim.g.molten_image_provider = 'wezterm'
        vim.g.molten_output_virt_lines = true
        vim.g.molten_virt_text_output = true
        vim.g.molten_use_border_highlights = true
        vim.g.molten_virt_lines_off_by_1 = true
        vim.g.molten_auto_image_popup = false

        -- Split window configuration
        vim.g.molten_split_direction = 'right' -- Options: "right", "left", "top", "bottom"
        vim.g.molten_split_size = 40 -- Percentage of screen for output window

        -- Jupytext configuration
        vim.g.jupytext_fmt = 'py:percent' -- Use percent format for Python files
        vim.g.jupytext_style = 'hydrogen' -- Use Hydrogen style for cell markers

        -- Enable Quarto features
        vim.g.quarto_enabled = true
    end,

    -- Main configuration
    config = function(opts)
        -- Helper function to initialize Molten buffer with appropriate kernel
        local function init_molten_buffer(e)
            vim.schedule(function()
                local kernels = vim.fn.MoltenAvailableKernels()

                -- Try to get kernel name from notebook metadata
                local function try_kernel_name()
                    local metadata = vim.json.decode(io.open(e.file, 'r'):read 'a')['metadata']
                    return metadata.kernelspec.name
                end

                -- Attempt to get kernel name, fallback to virtual env name
                local ok, kernel_name = pcall(try_kernel_name)
                if not ok or not vim.tbl_contains(kernels, kernel_name) then
                    kernel_name = nil
                    -- Try getting kernel from Quarto metadata
                    local quarto_kernel = vim.b.quarto_kernel
                    if quarto_kernel and vim.tbl_contains(kernels, quarto_kernel) then
                        kernel_name = quarto_kernel
                    else
                        -- Fallback to virtual env name
                        local venv = os.getenv 'VIRTUAL_ENV'
                        if venv ~= nil then
                            kernel_name = string.match(venv, '/.+/(.+)')
                        end
                    end
                end

                -- Initialize Molten with found kernel if available
                if kernel_name ~= nil and vim.tbl_contains(kernels, kernel_name) then
                    vim.cmd(('MoltenInit %s'):format(kernel_name))
                end
                vim.cmd 'MoltenImportOutput'
            end)
        end

        -- Set up autocommands for Jupyter notebook integration
        local jupyter_group = vim.api.nvim_create_augroup('MoltenJupyter', { clear = true })

        -- Auto-import output when opening notebook
        vim.api.nvim_create_autocmd({ 'BufAdd', 'BufRead', 'BufNewFile' }, {
            group = jupyter_group,
            pattern = { '*.ipynb', '*.qmd', '*.Rmd' },
            callback = init_molten_buffer,
        })

        -- Handle direct file opens
        vim.api.nvim_create_autocmd('BufEnter', {
            group = jupyter_group,
            pattern = { '*.ipynb', '*.qmd', '*.Rmd' },
            callback = function(e)
                if vim.api.nvim_get_vvar 'vim_did_enter' ~= 1 then
                    init_molten_buffer(e)
                end
            end,
        })

        -- Auto-export on save for ipynb files
        vim.api.nvim_create_autocmd('BufWritePost', {
            group = jupyter_group,
            pattern = { '*.ipynb' },
            callback = function()
                if require('molten.status').initialized() == 'Molten' then
                    vim.cmd 'MoltenExportOutput!'
                end
            end,
        })

        -- Set up filetype detection
        vim.filetype.add {
            extension = {
                ipynb = 'jupyter',
                qmd = 'quarto',
                Rmd = 'rmd',
            },
        }

        -- Configure Jupytext sync for relevant filetypes
        vim.api.nvim_create_autocmd('FileType', {
            group = jupyter_group,
            pattern = { 'python', 'jupyter', 'quarto', 'rmd' },
            callback = function()
                vim.opt_local.foldmethod = 'marker'
                vim.opt_local.commentstring = '# %%'
            end,
        })
    end,
}
