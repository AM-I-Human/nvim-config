return { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
        'saghen/blink.cmp',
        { 'williamboman/mason.nvim', config = true },
        { 'williamboman/mason-lspconfig.nvim' },
        { 'WhoIsSethDaniel/mason-tool-installer.nvim' },
        { 'j-hui/fidget.nvim', opts = {} },
        { 'folke/neodev.nvim', opts = {} },
        { 'jose-elias-alvarez/null-ls.nvim', opts = {} },
    },
    config = function()
        local capabilities = require('blink.cmp').get_lsp_capabilities()

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
            ['typescript-language-server'] = {
                filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact' },
                cmd = { 'typescript-language-server', '--stdio' },
            },

            -- Biome (Keep this if you use it!)
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
                'ruff',
                'typescript-language-server',
                'biome',
            },
            handlers = {
                function(server_name)
                    local server = servers[server_name] or {}
                    server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
                    -- Disable pyright format
                    if server_name == 'pyright' then
                        server.capabilities.textDocument.formatting = nil
                        server.capabilities.textDocument.rangeFormatting = nil
                    end

                    -- Load language-specific configuration (like for Python)
                    if server_name == 'pyright' or server_name == 'ruff' then --or server_name == "pylance"
                        local python_opts = require('plugins.lsp.python').setup()
                        server = vim.tbl_deep_extend('force', server, python_opts)
                    end

                    require('lspconfig')[server_name].setup(server)
                end,
            },
        }

        -- null-ls setup (MINIMAL - only for diagnostics if needed)
        local null_ls = require 'null-ls'
        null_ls.setup {
            sources = {
                -- Example: If you want to use a linter that's NOT handled by an LSP
                -- null_ls.builtins.diagnostics.eslint_d,
            },
        }

        --Format on save -- MOVED to conform.lua
        -- vim.api.nvim_create_autocmd({ "BufWritePre" }, {
        --     pattern = "*",
        --     callback = function(args)
        --         require("conform").format({ bufnr = args.buf })
        --     end,
        -- })

        local ensure_installed = vim.tbl_keys(servers or {})
        vim.list_extend(ensure_installed, {
            'stylua',
            'ruff',
            'pyright',
            'typescript-language-server',
            'black',
            'biome',
        })
        require('mason-tool-installer').setup { ensure_installed = ensure_installed }
    end,
}
