local opts = {
    mode = 'n', -- NORMAL mode
    prefix = '<leader>',
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = true, -- use `nowait` when creating keymaps
}
local vopts = {
    mode = 'v', -- VISUAL mode
    prefix = '<leader>',
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = true, -- use `nowait` when creating keymaps
}

return { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    config = function() -- This is the function that runs, AFTER loading
        local which_key_mappings = (require 'keymaps.keymaps').which_key_mappings
        -- Document existing key chains using pages
        require('which-key').register(which_key_mappings.pages.normal_mode)
        require('which-key').register(which_key_mappings.pages.visual_mode, { mode = 'v' })

        -- adding keymaps functions
        require('which-key').register(which_key_mappings.normal_mode, opts)
        require('which-key').register(which_key_mappings.visual_mode, vopts)
    end,
}
