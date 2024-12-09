local spinner_symbols = {
    '⠋',
    '⠙',
    '⠹',
    '⠸',
    '⠼',
    '⠴',
    '⠦',
    '⠧',
    '⠇',
    '⠏',
}

local spinner_index = 1
function next_spinner_symbol()
    spinner_index = (spinner_index % #spinner_symbols) + 1
    return spinner_symbols[spinner_index]
end
local processing = false
local group = vim.api.nvim_create_augroup('CodeCompanionHooks', {})

vim.api.nvim_create_autocmd({ 'User' }, {
    pattern = 'CodeCompanionRequest',
    group = group,
    callback = function(request)
        processing = (request.data.status == 'started')
    end,
})

return { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    dependencies = { 'GCBallesteros/NotebookNavigator.nvim' },
    config = function()
        require('mini.ai').setup { n_lines = 500 }

        -- Add/delete/replace surroundings (brackets, quotes, etc.)
        --
        -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
        -- - sd'   - [S]urround [D]elete [']quotes
        -- - sr)'  - [S]urround [R]eplace [)] [']
        require('mini.surround').setup {
            mappings = {
                add = 'gsa', -- Keep adding as is
                delete = 'ds', -- Change delete mapping to 'ds'
                find = 'gsf', -- Keep find as is
                find_left = 'gsF', -- Keep find left as is
                highlight = 'gsh', -- Keep highlight as is
                replace = 'gsr', -- Keep replace as is
                update_n_lines = 'gsn', -- Keep update n lines as is
            },
        }
        -- local hipatterns = require 'mini.hipatterns'
        -- hipatterns.setup {
        --     highlighters = {
        --         -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
        --         fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
        --         hack = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
        --         todo = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
        --         note = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },
        --
        --         -- Highlight hex color strings (`#rrggbb`) using that color
        --         hex_color = hipatterns.gen_highlighter.hex_color(),
        --     },
        -- }
        -- local nn = require 'notebook-navigator'
        --
        -- local opts = { highlighters = { cells = nn.minihipatterns_spec } }
        --

        -- require('mini.animate').setup()

        local statusline = require 'mini.statusline'
        statusline.setup {
            use_icons = vim.g.have_nerd_font,
            set_vim_settings = false,
            content = {
                active = function()
                    local mode, mode_hl = MiniStatusline.section_mode { trunc_width = 120 }

                    local recording = ''
                    if vim.fn.reg_recording() ~= '' then
                        recording = ('Recording on ' .. vim.fn.reg_recording())
                    end
                    local git = MiniStatusline.section_git { trunc_width = 40 }
                    local diff = MiniStatusline.section_diff { trunc_width = 75 }
                    local diagnostics = MiniStatusline.section_diagnostics { trunc_width = 75 }
                    local lsp = MiniStatusline.section_lsp { trunc_width = 75 }
                    local filename = MiniStatusline.section_filename { trunc_width = 140 }
                    local fileinfo = MiniStatusline.section_fileinfo { trunc_width = 120 }

                    local ollama_info = function()
                        local status = require('ollama').status()
                        if status == 'WORKING' then
                            return '󰚩 ' .. status -- nf-md-robot
                        end

                        return '󱙺 ' .. status -- nf-md-robot-outline
                    end
                    local ai_assistant_status = ollama_info()
                    local location = MiniStatusline.section_location { trunc_width = 75 }
                    local search = MiniStatusline.section_searchcount { trunc_width = 75 }

                    -- Usage of `MiniStatusline.combine_groups()` ensures highlighting and
                    -- correct padding with spaces between groups (accounts for 'missing'
                    -- sections, etc.)
                    return MiniStatusline.combine_groups {
                        { hl = mode_hl, strings = { mode } },
                        { hl = 'Cursor', strings = { recording } },
                        '%<', -- Mark general truncate point
                        { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics, lsp } },
                        '%<', -- Mark general truncate point
                        { hl = 'MiniStatuslineFilename', strings = { filename } },
                        '%=', -- End left alignment
                        { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
                        { hl = 'MiniStatuslineFileinfo', strings = { ai_assistant_status } },
                        { hl = mode_hl, strings = { search, location } },
                    }
                end,
            },
        }
        -- H.default_content_active

        -- H.default_content_inactive = function()
        --     return '%#MiniStatuslineInactive#%F%='
        -- end

        -- You can configure sections in the statusline by overriding their
        -- default behavior. For example, here we set the section for
        -- cursor location to LINE:COLUMN
        ---@diagnostic disable-next-line: duplicate-set-field
        statusline.section_location = function()
            return '%2l(%L)│%2v(%-2{virtcol("$") - 1})'
        end
        vim.opt.laststatus = 3

        -- ... and there is more!
        --  Check out: https://github.com/echasnovski/mini.nvim
    end,
}
