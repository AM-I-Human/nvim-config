return {
    'numToStr/Comment.nvim',
    opts = {
        ---Add a space b/w comment and the line
        padding = true,
        ---Whether the cursor should stay at its position
        sticky = true,
        ---Lines to be ignored while (un)comment
        ignore = nil,
        ---LHS of toggle mappings in NORMAL mode
        toggler = {
            -- -Line-comment toggle keymap
            line = '<leader>/',
            ---Block-comment toggle keymap
            block = '<leader><leader>/',
        },
        ---LHS of operator-pending mappings in NORMAL and VISUAL mode
        opleader = {
            ---Line-comment keymap
            line = '<leader>/',
            ---Block-comment keymap
            block = '<leader><leader>/',
        },
        ---LHS of extra mappings
        extra = {
            above = 'gcm',
            below = 'gco',
            eol = 'gcA',
        },
        ---Enable keybindings
        mappings = {
            basic = true,
            extra = false,
        },
        ---Function to call before (un)comment
        pre_hook = nil,
        ---Function to call after (un)comment
        post_hook = nil,
    },
}
