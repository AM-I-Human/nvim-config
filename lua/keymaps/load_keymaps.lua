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
    mode = mode_adapters[mode]
    local opt = generic_opts[mode] or generic_opts_any
    if type(val) == 'table' then
        opt = val[2]
        val = val[1]
        if type(opt) == 'string' then
            opt = { desc = opt }
        end
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
function M.load_mode(mode, keymaps)
    for k, v in pairs(keymaps) do
        if type(v) == 'table' and (type(v[1]) == 'string' or type(v[1]) == 'function') then
            -- Direct mapping with optional options table
            M.set_keymaps(mode, k, v)
        elseif type(v) == 'table' then
            -- Nested mappings
            for subk, subv in pairs(v) do
                M.set_keymaps(mode, k .. subk, subv)
            end
        else
            M.set_keymaps(mode, k, v)
        end
    end
end

-- Load key mappings for all provided modes
-- @param keymaps A list of key mappings for each mode
function M.load(keymaps)
    keymaps = keymaps or {}
    for mode, mapping in pairs(keymaps) do
        M.load_mode(mode, mapping)
    end
end

M.mappings = (require 'keymaps.keymaps').nvim_mappings

if IS_MAC then
    M.mappings.normal_mode['<A-Up>'] = M.mappings.normal_mode['<C-Up>']
    M.mappings.normal_mode['<A-Down>'] = M.mappings.normal_mode['<C-Down>']
    M.mappings.normal_mode['<A-Left>'] = M.mappings.normal_mode['<C-Left>']
    M.mappings.normal_mode['<A-Right>'] = M.mappings.normal_mode['<C-Right>']
end

M.load(M.mappings)
return M
