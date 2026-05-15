return { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    build = ':TSUpdate',
    lazy = false,
    config = function()
        -- Install parsers
        local parsers = {
            'bash', 'c', 'html', 'css', 'lua', 'luadoc', 'markdown', 'vim', 'vimdoc',
            'python', 'dart', 'regex', 'markdown_inline', 'sql', 'json', 'jsonc',
            'yaml', 'toml', 'java', 'javascript', 'typescript', 'dockerfile'
        }
        require('nvim-treesitter').install(parsers)

        -- Enable Treesitter highlighting
        vim.api.nvim_create_autocmd('FileType', {
            callback = function()
                pcall(vim.treesitter.start)
            end,
        })

        -- Enable Treesitter indentation
        vim.api.nvim_create_autocmd('FileType', {
            callback = function()
                vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end,
        })
    end,
}
