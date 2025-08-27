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
local group_code_companion = vim.api.nvim_create_augroup('CodeCompanionHooks', {})

vim.api.nvim_create_autocmd({ 'User' }, {
    pattern = 'CodeCompanionRequest',
    group = group_code_companion,
    callback = function(request)
        processing = (request.data.status == 'started')
    end,
})

return {
    'echasnovski/mini.nvim',
    version = false,
    config = function()
        -- ... (tutta la tua configurazione di mini.ai e mini.surround rimane invariata) ...
        require('mini.ai').setup { n_lines = 500 }
        require('mini.surround').setup {
            mappings = { add = 'gs', delete = 'gsd', find = 'gsf', find_left = 'gsF', highlight = 'gsh', replace = 'gsr', update_n_linse = 'gns' },
            suffix_last = 'l',
            suffix_next = 'n',
        }

        require('mini.files').setup {
            -- Customization of shown content
            content = {
                -- Predicate for which file system entries to show
                filter = nil,
                -- What prefix to show to the left of file system entry
                prefix = nil,
                -- In which order to show file system entries
                sort = nil,
            },

            -- Module mappings created only inside explorer.
            -- Use `''` (empty string) to not create one.
            mappings = {
                close = 'q',
                go_in = 'l',
                go_in_plus = 'L',
                go_out = 'h',
                go_out_plus = 'H',
                mark_goto = "'",
                mark_set = 'm',
                reset = '<BS>',
                reveal_cwd = '@',
                show_help = 'g?',
                synchronize = '=',
                trim_left = '<',
                trim_right = '>',
            },

            -- General options
            options = {
                -- Whether to delete permanently or move into module-specific trash
                permanent_delete = true,
                -- Whether to use for editing directories
                use_as_default_explorer = true,
            },

            -- Customization of explorer windows
            windows = {
                -- Maximum number of windows to show side by side
                max_number = 5, --math.huge,
                -- Whether to show preview of file/directory under cursor
                preview = true,
                -- Width of focused window
                width_focus = 60,
                -- Width of non-focused window
                width_nofocus = 40,
                -- Width of preview window
                width_preview = 200,
            },
        }

        vim.api.nvim_set_hl(0, 'MyRecordingHighlight', { bg = 'yellow', fg = 'black', bold = true })

        local statusline = require 'mini.statusline'

        ---
        -- Sezione VENV personalizzata (con la tua patch di sicurezza, che è un'ottima idea)
        ---
        local function section_venv(args)
            args = args or {}
            args.trunc_width = args.trunc_width or 80
            args.icon = args.icon or ''

            local ok, venv_selector = pcall(require, 'venv-selector')
            -- La tua patch è perfetta per gestire i casi limite durante l'avvio
            if not ok or venv_selector.get_active_venv == nil then
                return ''
            end

            local venv = venv_selector.venv()
            if venv and venv ~= '' then
                local venv_parts = vim.fn.split(venv, '/')
                local venv_name = venv_parts[#venv_parts]
                return args.icon .. ' ' .. venv_name
            else
                return args.icon .. ' Seleziona Venv'
            end
        end

        local jove_component = function()
            local ok, jove_commands = pcall(require, 'jove.commands')
            if not ok then
                return ''
            end
            return jove_commands.status_text()
        end

        statusline.setup {
            use_icons = vim.g.have_nerd_font,
            set_vim_settings = false,
            content = {
                active = function()
                    local mode, mode_hl = statusline.section_mode { trunc_width = 120 }
                    local recording = ''
                    if vim.fn.reg_recording() ~= '' then
                        recording = ('Recording on ' .. vim.fn.reg_recording())
                    end
                    local venv = section_venv { trunc_width = 100 }
                    local git = statusline.section_git { trunc_width = 75 }
                    local diff = statusline.section_diff { trunc_width = 75 }
                    local diagnostics = statusline.section_diagnostics { trunc_width = 75 }
                    local lsp = statusline.section_lsp { trunc_width = 75 }
                    local filename = statusline.section_filename { trunc_width = 140 }
                    local fileinfo = statusline.section_fileinfo { trunc_width = 120 }
                    local location = statusline.section_location { trunc_width = 75 }
                    local search = statusline.section_searchcount { trunc_width = 75 }
                    return statusline.combine_groups {
                        { hl = mode_hl, strings = { mode } },
                        { hl = 'MyRecordingHighlight', strings = { recording } },
                        {
                            hl = 'statuslineDevinfo',
                            strings = { jove_component() },
                        },
                        '%<',
                        { hl = 'statuslineDevinfo', strings = { section_venv(), git, diff, diagnostics, lsp } },
                        { hl = 'statuslineFilename', strings = { filename } },
                        '%=',
                        { hl = 'statuslineFileinfo', strings = { fileinfo, ai_assistant_status } },
                        { hl = mode_hl, strings = { search, location } },
                    }
                end,
            },
        }

        vim.api.nvim_create_autocmd('User', {
            pattern = 'VenvSelectorChanged',
            command = 'redrawstatus',
        })

        -- ... (il resto della tua configurazione)
        statusline.section_location = function()
            return '%2l(%L)│%2v(%-2{virtcol("$") - 1})'
        end
        vim.opt.laststatus = 3
    end,
}
