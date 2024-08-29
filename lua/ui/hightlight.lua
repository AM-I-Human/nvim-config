local M = {}

--- Notify the user with a message.
--- @param message string
--- @param level? "info" | "warn" | "error"
--- @param title? string
function M.notify(message, level, title)
    level = level or 'info'
    title = title or ' cyberdream.nvim'
    local level_int = level == 'info' and 2 or level == 'warn' and 3 or 4

    vim.notify(message, level_int, { title = title })
end

--- Set the syntax highlighting for a group.
--- @param syntax table
function M.syntax(syntax)
    for group, colors in pairs(syntax) do
        vim.api.nvim_set_hl(0, group, colors)
    end
end

--- Load the colorscheme.
--- @param theme table
function M.load(theme)
    -- only needed to clear when not the default colorscheme
    if vim.g.colors_name then
        vim.cmd 'hi clear'
    end

    vim.o.termguicolors = true
    vim.g.colors_name = 'cyberdream'

    M.syntax(theme.highlights)
end

--- Blend two colors together based on a weight.
--- @param color1 string
--- @param color2 string
--- @param weight? number
--- @return string
function M.blend(color1, color2, weight)
    weight = weight or 0.5

    local rgb1 = { tonumber(color1:sub(2, 3), 16), tonumber(color1:sub(4, 5), 16), tonumber(color1:sub(6, 7), 16) }
    local rgb2 = { tonumber(color2:sub(2, 3), 16), tonumber(color2:sub(4, 5), 16), tonumber(color2:sub(6, 7), 16) }
    local rgb_blended = {}
    for i = 1, 3 do
        rgb_blended[i] = math.floor(rgb1[i] * weight + rgb2[i] * (1 - weight))
    end

    return string.format('#%02x%02x%02x', rgb_blended[1], rgb_blended[2], rgb_blended[3])
end

--- Remove an element from a table.
--- @param table table
--- @param index number
--- @return table
function M.remove(table, index)
    local new_table = {}
    for i = 1, #table do
        if i ~= index then
            new_table[#new_table + 1] = table[i]
        end
    end

    return new_table
end

--- Parse a template string with a given table of colors.
--- @param template string
--- @param t table
--- @return string
function M.parse_extra_template(template, t)
    for k, v in pairs(t) do
        template = template:gsub('%${' .. k .. '}', v)
    end

    return template
end

--- Override options with a new table of values.
--- @param new_opts Config
--- @return Config
function M.set_options(new_opts)
    local opts = vim.g.cyberdream_opts
    vim.g.cyberdream_opts = vim.tbl_deep_extend('force', opts, new_opts)

    return vim.g.cyberdream_opts
end

--- Toggle the theme variant between "default" and "light".
--- @return string new variant
function M.toggle_theme_variant()
    local opts = vim.g.cyberdream_opts
    -- Handle the "auto" variant without overwriting the value in opts.
    if opts.theme.variant == 'auto' then
        return M.toggle_theme_auto()
    end

    opts.theme.variant = opts.theme.variant == 'default' and 'light' or 'default'
    M.set_options(opts)
    M.apply_options(opts)

    return opts.theme.variant
end

--- Used for toggling the theme variant when the variant is set to "auto". Uses the 'set background' command to toggle between 'light' and 'dark'.
--- @return string new variant
function M.toggle_theme_auto()
    local variant = vim.o.background
    if variant == 'dark' then
        variant = 'light'
    else
        variant = 'dark'
    end
    vim.cmd(':set background=' .. variant)
    return variant == 'dark' and 'default' or 'light'
end

--- Toggle theme for lualine
function M.toggle_lualine_theme()
    if package.loaded['lualine'] == nil then
        return
    end

    package.loaded['lualine.themes.cyberdream'] = nil
    local lualine_opts = require('lualine').get_config()
    local lualine_theme = require 'lualine.themes.cyberdream'
    lualine_opts.options.theme = lualine_theme
    require('lualine').setup(lualine_opts)
end

--- Get extension configuration
--- @param opts Config
--- @param t CyberdreamPalette
function M.get(opts, t)
    opts = opts or {}
    local highlights = {
        Comment = { fg = t.grey, italic = opts.italic_comments },
        ColorColumn = { bg = t.bgHighlight },
        Conceal = { fg = t.grey },
        Cursor = { fg = t.bg, bg = t.fg },
        ICursor = { fg = t.bg, bg = t.fg },
        CursorIM = { fg = t.bg, bg = t.fg },
        CursorColumn = { bg = t.bgHighlight },
        CursorLine = { bg = t.bgHighlight },
        Directory = { fg = t.blue },
        DiffAdd = { bg = M.blend(t.bg_solid, t.green, 0.8) },
        DiffChange = { bg = M.blend(t.bg_solid, t.blue, 0.8) },
        DiffDelete = { bg = M.blend(t.bg_solid, t.red, 0.8) },
        DiffText = { bg = M.blend(t.bg_solid, t.orange, 0.8) },
        Added = { fg = t.green },
        Removed = { fg = t.red },
        EndOfBuffer = { fg = t.bg },
        ErrorMsg = { fg = t.red },
        VertSplit = { fg = t.bgHighlight, bg = t.bg },
        WinSeparator = { fg = t.bgHighlight, bg = t.bg },
        Folded = { fg = t.grey, bg = t.bg },
        FoldColumn = { fg = t.grey, bg = t.bg },
        SignColumn = { fg = t.grey, bg = t.bg },
        SignColumnSB = { fg = t.grey, bg = t.bg },
        Substitute = { fg = t.red, bg = t.bgHighlight },
        LineNr = { fg = M.blend(t.bgHighlight, t.fg, 0.9) },
        CursorLineNr = { fg = t.grey },
        MatchParen = { fg = t.pink, bg = t.bgHighlight },
        ModeMsg = { fg = t.fg },
        MsgArea = { fg = t.fg },
        MoreMsg = { fg = t.blue },
        NonText = { fg = M.blend(t.bg_solid, t.grey, 0.55) },
        Normal = { fg = t.fg, bg = t.bg },
        NormalNC = { fg = t.fg, bg = t.bg },
        NormalFloat = { fg = t.fg, bg = t.bg },
        FloatTitle = { fg = t.cyan, bg = t.bg },
        FloatBorder = { fg = t.bgHighlight, bg = t.bg },
        Pmenu = { fg = t.fg, bg = t.bg },
        PmenuSel = { fg = t.fg, bg = t.bgHighlight },
        PmenuSbar = { fg = t.bg, bg = t.bgHighlight },
        PmenuThumb = { fg = t.bg, bg = t.bgHighlight },
        Question = { fg = t.yellow },
        QuickFixLine = { bg = t.bgHighlight },
        Search = { fg = t.bgAlt, bg = t.fg },
        IncSearch = { fg = t.bgAlt, bg = t.cyan },
        CurSearch = { fg = t.bgAlt, bg = t.cyan },
        SpecialKey = { fg = t.grey },
        SpellBad = { sp = t.red, undercurl = true },
        SpellCap = { sp = t.yellow, undercurl = true },
        SpellLocal = { sp = t.blue, undercurl = true },
        SpellRare = { sp = t.purple, undercurl = true },
        StatusLine = { fg = t.fg, bg = t.bg },
        StatusLineNC = { fg = t.grey, bg = t.bg },
        TabLine = { fg = t.grey, bg = t.bg },
        TabLineFill = { fg = t.grey, bg = t.bgHighlight },
        TabLineSel = { fg = t.fg, bg = t.bgHighlight },
        WinBar = { fg = t.grey, bg = t.bg },
        WinBarNC = { fg = t.grey, bg = t.bg },
        Title = { fg = t.fg },
        Visual = { bg = t.bgHighlight },
        VisualNOS = { bg = t.bgHighlight },
        WarningMsg = { fg = t.orange },
        Whitespace = { fg = t.grey },
        WildMenu = { fg = t.bg, bg = t.blue },

        Constant = { fg = t.pink },
        String = { fg = t.green },
        Character = { fg = t.green },
        Boolean = { fg = t.cyan },
        Number = { fg = t.orange },

        Identifier = { fg = t.fg },
        Function = { fg = t.blue },
        Statement = { fg = t.magenta },
        Operator = { fg = t.purple },
        Keyword = { fg = t.orange },
        PreProc = { fg = t.cyan },
        Label = { fg = t.orange },

        Type = { fg = t.purple },

        Special = { fg = t.pink },
        Delimiter = { fg = t.fg },

        Debug = { fg = t.orange },

        Underlined = { underline = true },
        Bold = { bold = true },
        Italic = { italic = true },

        Error = { fg = t.red },
        Todo = { fg = t.purple, bold = true },

        qfLineNr = { fg = t.grey },
        qfFileName = { fg = t.blue },

        htmlH1 = { fg = t.orange, bold = true },
        htmlH2 = { fg = t.orange, bold = true },

        mkdCodeDelimiter = { fg = t.grey },
        mkdCodeStart = { fg = t.blue },
        mkdCodeEnd = { fg = t.blue },

        markdownHeadingDelimiter = { fg = t.grey },
        markdownCode = { fg = t.cyan },
        markdownCodeBlock = { fg = t.cyan },
        markdownH1 = { fg = t.orange, bold = true },
        markdownH2 = { fg = t.cyan, bold = true },
        markdownH3 = { fg = t.blue, bold = true },
        markdownH4 = { fg = t.purple, bold = true },
        markdownH5 = { fg = t.magenta, bold = true },
        markdownH6 = { fg = t.green, bold = true },
        markdownLinkText = { fg = t.blue, underline = true },

        LspReferenceText = { bg = t.bgHighlight },
        LspReferenceRead = { bg = t.bgHighlight },
        LspReferenceWrite = { bg = t.bgHighlight },

        DiagnosticError = { fg = t.red },
        DiagnosticWarn = { fg = t.yellow },
        DiagnosticInfo = { fg = t.blue },
        DiagnosticHint = { fg = t.cyan },
        DiagnosticUnnecessary = { fg = t.grey },

        DiagnosiiucVirtualTextError = { fg = t.red },
        DiagnosticVirtualTextWarn = { fg = t.yellow },
        DiagnosticVirtualTextInfo = { fg = t.blue },
        DiagnosticVirtualTextHint = { fg = t.cyan },

        DiagnosticUnderlineError = { undercurl = true, sp = t.red },
        DiagnosticUnderlineWarn = { undercurl = true, sp = t.yellow },
        DiagnosticUnderlineInfo = { undercurl = true, sp = t.blue },
        DiagnosticUnderlineHint = { undercurl = true, sp = t.cyan },

        LspSignatureActiveParameter = { fg = t.orange },
        LspCodeLens = { fg = t.grey },
        LspInlayHint = { fg = t.grey },
        LspInfoBorder = { fg = t.bg },
    }

    return highlights
end
return M
