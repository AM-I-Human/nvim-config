local Table = {}

--- Find the first entry for which the predicate returns true.
-- @param t The table
-- @param predicate The function called for each entry of t
-- @return The entry for which the predicate returned True or nil
function Table.find_first(t, predicate)
    for _, entry in pairs(t) do
        if predicate(entry) then
            return entry
        end
    end
    return nil
end

--- Check if the predicate returns True for at least one entry of the table.
-- @param t The table
-- @param predicate The function called for each entry of t
-- @return True if predicate returned True at least once, false otherwise
function Table.contains(t, predicate)
    return Table.find_first(t, predicate) ~= nil
end

function Table.kpairs(t)
    local index
    return function()
        local value
        while true do
            index, value = next(t, index)
            if type(index) ~= 'number' or math.floor(index) ~= index then
                break
            end
        end
        return index, value
    end
end

function Table.ireduce(tbl, func, acc)
    for i, v in ipairs(tbl) do
        acc = func(acc, v, i)
    end
    return acc
end

function Table.kreduce(tbl, func, acc)
    for i, v in pairs(tbl) do
        if type(i) == 'string' then
            acc = func(acc, v, i)
        end
    end
    return acc
end

function Table.reduce(tbl, func, acc)
    for i, v in pairs(tbl) do
        acc = func(acc, v, i)
    end
    return acc
end

function Table.find_index(tbl, func)
    for index, item in ipairs(tbl) do
        if func(item, index) then
            return index
        end
    end

    return nil
end

function Table.isome(tbl, func)
    for index, item in ipairs(tbl) do
        if func(item, index) then
            return true
        end
    end

    return false
end

function Table.ifind(tbl, func)
    for index, item in ipairs(tbl) do
        if func(item, index) then
            return item
        end
    end

    return nil
end

function Table.find_last_index(tbl, func)
    for index = #tbl, 1, -1 do
        if func(tbl[index], index) then
            return index
        end
    end
end

function Table.slice(tbl, startIndex, endIndex)
    local sliced = {}
    endIndex = endIndex or #tbl

    for index = startIndex, endIndex do
        table.insert(sliced, tbl[index])
    end

    return sliced
end

function Table.concat(...)
    local concatenated = {}

    for _, tbl in ipairs { ... } do
        for _, value in ipairs(tbl) do
            table.insert(concatenated, value)
        end
    end

    return concatenated
end

function Table.kmap(tbl, func)
    return Table.kreduce(tbl, function(new_tbl, value, key)
        table.insert(new_tbl, func(value, key))
        return new_tbl
    end, {})
end

function Table.imap(tbl, func)
    return Table.ireduce(tbl, function(new_tbl, value, index)
        table.insert(new_tbl, func(value, index))
        return new_tbl
    end, {})
end

function Table.ieach(tbl, func)
    for index, element in ipairs(tbl) do
        func(element, index)
    end
end

function Table.keach(tbl, func)
    for key, element in Table.kpairs(tbl) do
        func(element, key)
    end
end

function Table.keys(tbl)
    local keys = {}
    for key, _ in Table.kpairs(tbl) do
        table.insert(keys, key)
    end
    return keys
end

function Table.indexes(tbl)
    local indexes = {}
    for key, _ in ipairs(tbl) do
        table.insert(indexes, key)
    end
    return indexes
end

function Table.bind(func, ...)
    local boundArgs = { ... }

    return function(...)
        return func(Table.unpack(boundArgs), ...)
    end
end

function Table.ifilter(tbl, pred_fn)
    return Table.ireduce(tbl, function(new_tbl, value, index)
        if pred_fn(value, index) then
            table.insert(new_tbl, value)
        end
        return new_tbl
    end, {})
end

function Table.ireject(tbl, pred_fn)
    return Table.ifilter(tbl, function(value, index)
        return not pred_fn(value, index)
    end)
end

function Table.kfilter(tbl, pred_fn)
    return Table.kreduce(tbl, function(new_tbl, value, key)
        if pred_fn(value, key) then
            new_tbl[key] = value
        end
        return new_tbl
    end, {})
end

function Table.kreject(tbl, pred_fn)
    return Table.kfilter(tbl, function(value, index)
        return not pred_fn(value, index)
    end)
end

function Table.switch(param, t)
    local case = t[param]
    if case then
        return case()
    end
    local defaultFn = t['default']
    return defaultFn and defaultFn() or nil
end

function Table.trim(str)
    return (str:gsub('^%s*(.-)%s*$', '%1'))
end

function Table.ignore() end

function Table.always(value)
    return function()
        return value
    end
end

function Table.identity(value)
    return value
end

function Table.debounce(fn, ms)
    local timer = vim.loop.new_timer()

    local function wrapped_fn(...)
        local args = { ... }
        timer:stop()
        timer:start(ms, 0, function()
            pcall(
                vim.schedule_wrap(function(...)
                    fn(...)
                    timer:stop()
                end),
                select(1, Table.unpack(args))
            )
        end)
    end
    return wrapped_fn, timer
end

Table.pack = table.pack or function(...)
    return { n = select('#', ...), ... }
end

---@diagnostic disable-next-line: deprecated
Table.unpack = table.unpack or unpack

function Table.eq(x, y)
    return x == y
end

function Table.constant(x)
    return function()
        return x
    end
end

function Table.clamp(value, min, max)
    return math.min(math.max(value, min), max)
end

function Table.isa(object, class)
    local mt = getmetatable(object)

    if mt and object then
        return type(object) == 'table' and mt.__index == class
    end

    return false
end

function Table.default_to(value, default_value)
    return vim.F.if_nil(value, default_value)
end

function Table.merge(fst, snd)
    return vim.tbl_extend('force', fst, snd)
end

function Table.deep_merge(fst, snd)
    return vim.tbl_deep_extend('force', fst, snd)
end

function Table.preserve_cursor_position(fn)
    local line, col = Table.unpack(vim.api.nvim_win_get_cursor(0))

    fn()

    vim.schedule(function()
        local lastline = vim.fn.line '$'

        if line > lastline then
            line = lastline
        end

        vim.api.nvim_win_set_cursor(0, { line, col })
    end)
end

function Table.log(...)
    local is_fidget_installed, fidget = pcall(require, 'fidget')
    local debug_value = vim.inspect { ... }

    if is_fidget_installed then
        return fidget.notify(debug_value)
    end

    vim.notify(debug_value)
end

function Table.print(t)
    local function recurse(tbl, indent)
        indent = indent or 0
        local indentStr = string.rep('\t', indent)
        for k, v in pairs(tbl) do
            if type(v) == 'table' then
                print(indentStr .. tostring(k) .. ' = {')
                recurse(v, indent + 1)
                print(indentStr .. '}')
            else
                print(indentStr .. tostring(k) .. ' = ' .. tostring(v))
            end
        end
    end

    recurse(t, 0)
end

return Table
