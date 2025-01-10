return {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    lazy = true,
    event = 'VeryLazy',
    opts = {
        default_file_explorer = true,
        columns = {
            'icon',
            'fullpath',
            -- "permissions",
            'size',
            'mtime',
        },
        buf_options = {
            buflisted = false,
            bufhidden = 'hide',
        },
        win_options = {
            wrap = false,
            signcolumn = 'no',
            cursorcolumn = false,
            foldcolumn = '0',
            spell = false,
            list = false,
            conceallevel = 3,
            concealcursor = 'nvic',
        },
        delete_to_trash = true,
        skip_confirm_for_simple_edits = true,
        prompt_save_on_select_new_entry = true,
        cleanup_delay_ms = 2000,
        lsp_file_methods = {
            timeout_ms = 1000,
            autosave_changes = false,
        },
        constrain_cursor = 'editable',
        experimental_watch_for_changes = true,
        -- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
        -- options with a `callback` (e.g. { callback = function() ... end, desc = "", mode = "n" })
        -- Additionally, if it is a string that matches "actions.<name>",
        -- it will use the mapping at require("oil.actions").<name>
        -- Set to `false` to remove a keymap
        -- See :help oil-actions for a list of all available actions
        --
        keymaps = {
            ['g?'] = 'actions.show_help',
            ['<CR>'] = 'actions.select',
            ['<C-s>'] = 'actions.select_vsplit',
            ['<C-h>'] = 'actions.select_split',
            ['<C-t>'] = 'actions.select_tab',
            ['<C-p>'] = 'actions.preview',
            ['<C-c>'] = 'actions.close',
            ['<C-l>'] = 'actions.refresh',
            ['-'] = 'actions.parent',
            ['_'] = 'actions.open_cwd',
            ['`'] = 'actions.cd',
            ['~'] = 'actions.tcd',
            ['gs'] = 'actions.change_sort',
            ['gx'] = 'actions.open_external',
            ['g.'] = 'actions.toggle_hidden',
            ['g\\'] = 'actions.toggle_trash',
        },
        -- Set to false to disable all of the above keymaps
        use_default_keymaps = true,
        view_options = {
            show_hidden = true,
            is_hidden_file = function(name, bufnr)
                return vim.startswith(name, '.')
            end,
            is_always_hidden = function(name, bufnr)
                return false
            end,
            -- Sort file names in a more intuitive order for humans. Is less performant,
            -- so you may want to set to false if you work with large directories.
            natural_order = true,
            sort = {
                { 'type', 'asc' },
                { 'name', 'asc' },
            },
        },
        extra_scp_args = {},
        git = {
            -- Return true to automatically git add/mv/rm files
            add = function(path)
                return false
            end,
            mv = function(src_path, dest_path)
                return false
            end,
            rm = function(path)
                return false
            end,
        },
        float = {
            padding = 2,
            max_width = 0,
            max_height = 0,
            border = 'rounded',
            win_options = {
                winblend = 0,
            },
            override = function(conf)
                return conf
            end,
        },
        preview = {
            -- Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
            -- min_width and max_width can be a single value or a list of mixed integer/float types.
            -- max_width = {100, 0.8} means "the lesser of 100 columns or 80% of total"
            max_width = 0.9,
            -- min_width = {40, 0.4} means "the greater of 40 columns or 40% of total"
            min_width = { 40, 0.4 },
            -- optionally define an integer/float for the exact width of the preview window
            width = nil,
            -- Height dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
            -- min_height and max_height can be a single value or a list of mixed integer/float types.
            -- max_height = {80, 0.9} means "the lesser of 80 columns or 90% of total"
            max_height = 0.9,
            -- min_height = {5, 0.1} means "the greater of 5 columns or 10% of total"
            min_height = { 5, 0.1 },
            -- optionally define an integer/float for the exact height of the preview window
            height = nil,
            border = 'rounded',
            win_options = {
                winblend = 0,
            },
            -- Whether the preview window is automatically updated when the cursor is moved
            update_on_cursor_moved = true,
        },
        -- Configuration for the floating progress window
        progress = {
            max_width = 0.9,
            min_width = { 40, 0.4 },
            width = nil,
            max_height = { 10, 0.9 },
            min_height = { 5, 0.1 },
            height = nil,
            border = 'rounded',
            minimized_border = 'none',
            win_options = {
                winblend = 0,
            },
        },
        -- Configuration for the floating SSH window
        ssh = {
            border = 'rounded',
        },
        -- Configuration for the floating keymaps help window
        keymaps_help = {
            border = 'rounded',
        },
    },
}
