local M = {}
local generic_opts_any = { noremap = true, silent = true }

local generic_opts = {
    insert_mode = generic_opts_any,
    normal_mode = generic_opts_any,
    visual_mode = generic_opts_any,
    visual_block_mode = generic_opts_any,
    command_mode = generic_opts_any,
    operator_pending_mode = generic_opts_any,
    term_mode = { silent = true },
    -- select_mode = generic_opts_any,
}

local mode_adapters = {
    insert_mode = 'i',
    normal_mode = 'n',
    term_mode = 't',
    visual_mode = 'v',
    visual_block_mode = 'x',
    command_mode = 'c',
    operator_pending_mode = 'o',
    select_mode = 's',
}
-- Unsets all keybindings defined in keymaps
-- @param keymaps The table of key mappings containing a list per mode (normal_mode, insert_mode, ..)
function M.clear(keymaps)
    local default = M.get_defaults()
    for mode, mappings in pairs(keymaps) do
        local translated_mode = mode_adapters[mode] and mode_adapters[mode] or mode
        for key, _ in pairs(mappings) do
            -- some plugins may override default bindings that the user hasn't manually overriden
            if default[mode][key] ~= nil or (default[translated_mode] ~= nil and default[translated_mode][key] ~= nil) then
                pcall(vim.api.nvim_del_keymap, translated_mode, key)
            end
        end
    end
end

-- Set key mappings individually
-- @param mode The keymap mode, can be one of the keys of mode_adapters
-- @param key The key of keymap
-- @param val Can be form as a mapping or tuple of mapping and user defined opt
function M.set_keymaps(mode, key, val)
    local opt = generic_opts[mode] or generic_opts_any
    mode = mode_adapters[mode]
    if type(val) == 'table' then
        local user_opt = val[2]
        val = val[1]
        if type(user_opt) == 'string' then
            user_opt = { desc = user_opt }
        end
        opt = vim.tbl_deep_extend('force', opt, user_opt or {})
    end
    if val then
        vim.keymap.set(mode, key, val, opt)
    else
        pcall(vim.api.nvim_del_keymap, mode, key)
    end
end

-- Load key mappings for a given mode
-- @param mode The keymap mode, can be one of the keys of mode_adapters
-- @param keymaps The list of key mappings
function M.load_mode(mode, keymaps, prefix)
    prefix = prefix or ''
    for k, v in pairs(keymaps) do
        if k ~= 'name' then
            if type(v) == 'table' and (type(v[1]) == 'string' or type(v[1]) == 'function') then
                -- Direct mapping with optional options table
                M.set_keymaps(mode, prefix .. k, v)
            elseif type(v) == 'table' then
                -- Nested mappings
                M.load_mode(mode, v, prefix .. k)
            else
                M.set_keymaps(mode, prefix .. k, v)
            end
        end
    end
end

-- Load key mappings for all provided modes
-- @param keymaps A list of key mappings for each mode
function M.load(keymaps, prefix)
    keymaps = keymaps or {}
    for mode, mapping in pairs(keymaps) do
        if mode ~= 'pages' then
            M.load_mode(mode, mapping, prefix)
        end
    end
end

M.mappings = (require 'keymaps.keymaps').nvim_mappings
M.leader_mappings = (require 'keymaps.keymaps').which_key_mappings

if IS_MAC then
    M.mappings.normal_mode['<A-Up>'] = M.mappings.normal_mode['<C-Up>']
    M.mappings.normal_mode['<A-Down>'] = M.mappings.normal_mode['<C-Down>']
    M.mappings.normal_mode['<A-Left>'] = M.mappings.normal_mode['<C-Left>']
    M.mappings.normal_mode['<A-Right>'] = M.mappings.normal_mode['<C-Right>']
end

M.load(M.mappings)
M.load(M.leader_mappings, '<leader>')
return M
