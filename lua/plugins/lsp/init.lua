return { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
        'saghen/blink.cmp',
        { 'williamboman/mason.nvim', config = true },
        { 'williamboman/mason-lspconfig.nvim' },
        { 'WhoIsSethDaniel/mason-tool-installer.nvim' },
        { 'j-hui/fidget.nvim', opts = {} },
        { 'folke/neodev.nvim', opts = {} },
        {
            'stevearc/conform.nvim',
        },
    },
    config = function()
        local capabilities = require('blink.cmp').get_lsp_capabilities()
        capabilities.textDocument.completion.completionItem.snippetSupport = true

        -- LSP Attach/Detach Autocommands (Keep these)
        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
            callback = function(event)
                local client = vim.lsp.get_client_by_id(event.data.client_id)
                if client and client.server_capabilities.documentHighlightProvider then
                    local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
                    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                        buffer = event.buf,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.document_highlight,
                    })
                    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                        buffer = event.buf,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.clear_references,
                    })
                end
            end,
        })

        vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
            callback = function(event)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event.buf }
            end,
        })

        -- General LSP server configurations
        local servers = {
            lua_ls = {
                settings = {
                    Lua = {
                        completion = {
                            callSnippet = 'Replace',
                        },
                        workspace = {
                            checkThirdParty = false,
                        },
                    },
                },
            },

            jsonls = {
                settings = {
                    json = {
                        schemas = require('schemastore').json.schemas(),
                        validate = { enable = true },
                    },
                },
            },

            yamlls = {
                settings = {
                    yaml = {
                        schemas = require('schemastore').yaml.schemas(),
                        validate = true,
                        format = { enable = true }, -- Keep this enabled
                    },
                },
            },
            ts_ls = {
                filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact' },
            },

            biome = {
                filetypes = {
                    'javascript',
                    'javascriptreact',
                    'typescript',
                    'typescriptreact',
                    'json',
                    'jsonc',
                    'markdown',
                },
            },
        }

        -- Mason setup
        require('mason').setup()

        -- mason-lspconfig setup
        require('mason-lspconfig').setup {
            -- List *ALL* servers you want mason-lspconfig to manage:
            ensure_installed = {
                'lua_ls',
                'jsonls',
                'yamlls',
                'pyright',
                'ruff', -- Just 'ruff' now
                'ts_ls',
                'biome',
            },
            automatic_installation = true, -- Let mason-tool-installer handle it
            handlers = {
                function(server_name)
                    local server = servers[server_name] or {}
                    server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})

                    if server_name == 'pyright' then
                        local python_opts = require('plugins.lsp.python').setup()
                        server = vim.tbl_deep_extend('force', server, python_opts)
                    end

                    require('lspconfig')[server_name].setup(server)
                end,
            },
        }

        local ensure_installed = vim.tbl_keys(servers or {})
        vim.list_extend(ensure_installed, {
            'stylua',
            'ruff', -- Just 'ruff' for mason-tool-installer too
            'pyright',
            'ts_ls',
            'black',
            'biome',
            'sqlfluff',
        })
        require('mason-tool-installer').setup {
            ensure_installed = ensure_installed,
            auto_update = true,
            run_on_start = true,
            start_delay = 3000, -- 3 second delay
            debounce_hours = 5,
            --to make use of the post install hook
            install_hook = function(package)
                local python_config = require 'plugins.lsp.python' -- Adjust path as needed
                if python_config.mason_post_install then
                    python_config.mason_post_install(package)
                end
            end,
        }
    end,
}
