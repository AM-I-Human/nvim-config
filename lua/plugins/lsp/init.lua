return { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {

        'saghen/blink.cmp',
        { 'williamboman/mason.nvim', config = true },
        { 'williamboman/mason-lspconfig.nvim' },
        { 'WhoIsSethDaniel/mason-tool-installer.nvim' },
        { 'j-hui/fidget.nvim', opts = {} },
        { 'folke/neodev.nvim', opts = {} },
    },
    config = function()
        local capabilities = require('blink.cmp').get_lsp_capabilities()
        require('lspconfig').lua_ls.setup { capabilites = capabilities }
        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
            callback = function(event)
                -- In this case, we create a function that lets us more easily define mappings specific
                -- for LSP related items. It sets the mode, buffer and description for us each time.
                -- The following two autocommands are used to highlight references of the
                -- word under your cursor when your cursor rests there for a little while.
                --    See `:help CursorHold` for information about when this is executed
                --
                -- When you move your cursor, the highlights will be cleared (the second autocommand).
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

        --[[ Increasing LSP capabilities]]
        --
        -- local capabilities = vim.lsp.protocol.make_client_capabilities()
        -- capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

        -- Enable the following language servers
        --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
        --
        --  Add any additional override configuration in the following tables. Available keys are:
        --  - cmd (table): Override the default command used to start the server
        --  - filetypes (table): Override the default list of associated filetypes for the server
        --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
        --  - settings (table): Override the default settings passed when initializing the server.
        --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
        local servers = {
            -- Existing servers
            pyright = {},
            ruff = {},
            pylsp = {},
            ['typescript-language-server'] = {
                filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx', 'json' },
                cmd = { 'typescript-language-server', '--stdio' },
            },
            lua_ls = {
                settings = {
                    Lua = {
                        completion = {
                            callSnippet = 'Replace',
                        },
                        python = {
                            analysis = {
                                extraPaths = { './src' },
                            },
                        },
                    },
                },
            },

            -- Add jsonls (JSON Language Server)
            jsonls = {
                settings = {
                    json = {
                        schemas = require('schemastore').json.schemas(), -- Use SchemaStore for JSON
                        validate = { enable = true }, -- Enable JSON validation
                    },
                },
            },

            -- Add yamlls (YAML Language Server)
            yamlls = {
                settings = {
                    yaml = {
                        schemas = require('schemastore').yaml.schemas(), -- Use SchemaStore for YAML
                        validate = true, -- Enable YAML validation
                        format = { enable = true }, -- Enable YAML formatting
                    },
                },
            },

            -- Add Biome integration via null-ls (for linting and formatting)
        }
        require('mason').setup {}
        local ensure_installed = vim.tbl_keys(servers or {})
        vim.list_extend(ensure_installed, {
            'stylua',
            'ruff',
            'debugpy',
            'pyright',
            'python-lsp-server',
            'typescript-language-server', -- Add this line
            'biome',
        })

        require('mason-registry.index')['pylance'] = 'pylance'
        require('mason-registry'):on('package:install:success', require('plugins.lsp.python').mason_post_install)
        -- require('mason-registry'):on('package:install:success', function(pkg)
        --     local pkg_name = pkg.name:lower()
        --
        --     if pkg_name:match 'python' then
        --         require('plugins.lsp.python').mason_post_install()
        --     elseif pkg_name:match 'markdown' then
        --         require('plugins.lsp.markdown').mason_post_install()
        --     end
        -- end)
        require('mason-tool-installer').setup { ensure_installed = ensure_installed }
        -- local Package = require'mason-core.package'
        -- local registry = require "mason-registry"
        --     install = function(ctx)
        --         local pylsp = registry.get_package("python-lsp-server")
        --         assert(pylsp:is_installed(), "python-lsp-server is not installed")
        --         ctx.spawn[pylsp:get_install_path() .. "/venv/bin/python"] {
        --             "-m", "pip", "install", "python-lsp-black"
        --         }
        --         ctx.receipt:with_primary_source(ctx.receipt.pip3('python-lsp-black'))
        --     end,
        require('mason-lspconfig').setup {
            handlers = {
                function(server_name)
                    local server = servers[server_name] or {}
                    -- This handles overriding only values explicitly passed
                    -- by the server configuration above. Useful when disabling
                    -- certain features of an LSP (for example, turning off formatting for tsserver)
                    server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
                    require('lspconfig')[server_name].setup(server)
                end,
            },
        }
    end,
}
