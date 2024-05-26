return { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
        -- Better Around/Inside textobjects
        --
        -- Examples:
        --  - va)  - [V]isually select [A]round [)]paren
        --  - yinq - [Y]ank [I]nside [N]ext [']quote
        --  - ci'  - [C]hange [I]nside [']quote
        require('mini.ai').setup { n_lines = 500 }

        -- Add/delete/replace surroundings (brackets, quotes, etc.)
        --
        -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
        -- - sd'   - [S]urround [D]elete [']quotes
        -- - sr)'  - [S]urround [R]eplace [)] [']
        require('mini.surround').setup()

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
