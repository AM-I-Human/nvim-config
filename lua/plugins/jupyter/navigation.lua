return {
    'GCBallesteros/NotebookNavigator.nvim',
    keys = {
        {
            ']h',
            function()
                require('notebook-navigator').move_cell 'd'
            end,
        },
        {
            '[h',
            function()
                require('notebook-navigator').move_cell 'u'
            end,
        },
        { '<leader>X', "<cmd>lua require('notebook-navigator').run_cell()<cr>" },
        { '<leader>x', "<cmd>lua require('notebook-navigator').run_and_move()<cr>" },
    },
    dependencies = {
        'echasnovski/mini.comment',
        'hkupty/iron.nvim', -- repl provider
        -- "akinsho/toggleterm.nvim", -- alternative repl provider
        'benlubas/molten-nvim', -- alternative repl provider
        'anuvyklack/hydra.nvim',
    },
    event = 'VeryLazy',
    opts = {
        -- Code cell marker. Cells start with the marker and end either at the beginning
        -- of the next cell or at the end of the file.
        -- By default, uses language-specific double percent comments like `# %%`.
        -- This can be overridden for each language with this setting.
        cell_markers = {
            -- python = "# %%",
        },
        -- If not `nil` the keymap defined in the string will activate the hydra head.
        -- If you don't want to use hydra you don't need to install it either.
        activate_hydra_keys = nil,
        -- If `true` a hint panel will be shown when the hydra head is active. If `false`
        -- you get a minimalistic hint on the command line.
        show_hydra_hint = true,
        -- Mappings while the hydra head is active.
        -- Any of the mappings can be set to "nil", the string! Not the value! to unamp it
        hydra_keys = {
            comment = 'c',
            run = 'X',
            run_and_move = 'x',
            move_up = 'k',
            move_down = 'j',
            add_cell_before = 'a',
            add_cell_after = 'b',
        },
        -- The repl plugin with which to interface
        -- Current options: "iron" for iron.nvim, "toggleterm" for toggleterm.nvim,
        -- "molten" for molten-nvim or "auto" which checks which of the above are
        -- installed
        repl_provider = 'auto',
        -- Syntax based highlighting. If you don't want to install mini.hipattners or
        -- enjoy a more minimalistic look
        syntax_highlight = false,
        -- (Optional) for use with `mini.hipatterns` to highlight cell markers
        cell_highlight_group = 'Folded',
    },
}
