return {
    'kevinhwang91/nvim-ufo',
    dependencies = {
        'kevinhwang91/promise-async',
    },
    lazy = true,
    opts = {
        fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
            local newVirtText = {}
            local totalLines = vim.api.nvim_buf_line_count(0)
            local foldedLines = endLnum - lnum
            local suffix = ('  %d %d%%'):format(foldedLines, foldedLines / totalLines * 100)
            local sufWidth = vim.fn.strdisplaywidth(suffix)
            local targetWidth = width - sufWidth
            local curWidth = 0
            for _, chunk in ipairs(virtText) do
                local chunkText = chunk[1]
                local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                if targetWidth > curWidth + chunkWidth then
                    table.insert(newVirtText, chunk)
                else
                    chunkText = truncate(chunkText, targetWidth - curWidth)
                    local hlGroup = chunk[2]
                    table.insert(newVirtText, { chunkText, hlGroup })
                    chunkWidth = vim.fn.strdisplaywidth(chunkText)
                    -- str width returned from truncate() may less than 2nd argument, need padding
                    if curWidth + chunkWidth < targetWidth then
                        suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
                    end
                    break
                end
                curWidth = curWidth + chunkWidth
            end
            local rAlignAppndx = math.max(math.min(vim.opt.textwidth['_value'], width - 1) - curWidth - sufWidth, 0)
            suffix = (' '):rep(rAlignAppndx) .. suffix
            table.insert(newVirtText, { suffix, 'MoreMsg' })
            return newVirtText
        end,

        provider_selector = function(bufnr, filetype, buftype)
            return { 'treesitter', 'indent' }
        end,
        -- open_fold_hl_timeout = {
        --     description = [[Time in millisecond between the range to be highlgihted and to be cleared
        --             while opening the folded line, `0` value will disable the highlight]],
        --     default = 400,
        -- },
        -- -- provider_selector = {
        -- --     description = [[A function as a selector for fold providers. For now, there are
        -- --             'lsp' and 'treesitter' as main provider, 'indent' as fallback provider]],
        -- --     default = nil,
        -- -- },
        -- close_fold_kinds_for_ft = {
        --     description = [[After the buffer is displayed (opened for the first time), close the
        --             folds whose range with `kind` field is included in this option. For now,
        --             'lsp' provider's standardized kinds are 'comment', 'imports' and 'region'.
        --             This option is a table with filetype as key and fold kinds as value. Use a
        --             default value if value of filetype is absent.
        --             Run `UfoInspect` for details if your provider has extended the kinds.]],
        --     default = { default = {} },
        -- },
        -- fold_virt_text_handler = {
        --     description = [[A function customize fold virt text, see ### Customize fold text]],
        --     default = nil,
        -- },
        -- enable_get_fold_virt_text = {
        --     description = [[Enable a function with `lnum` as a parameter to capture the virtual text
        --             for the folded lines and export the function to `get_fold_virt_text` field of
        --             ctx table as 6th parameter in `fold_virt_text_handler`]],
        --     default = false,
        -- },
        -- preview = {
        --     description = [[Configure the options for preview window and remap the keys for current
        --             buffer and preview buffer if the preview window is displayed.
        --             Never worry about the users's keymaps are overridden by ufo, ufo will save
        --             them and restore them if preview window is closed.]],
        --     win_config = {
        --         border = {
        --             description = [[The border for preview window,
        --             `:h nvim_open_win() | call search('border:')`]],
        --             default = 'rounded',
        --         },
        --         winblend = {
        --             description = [[The winblend for preview window, `:h winblend`]],
        --             default = 12,
        --         },
        --         winhighlight = {
        --             description = [[The winhighlight for preview window, `:h winhighlight`]],
        --             default = 'Normal:Normal',
        --         },
        --         maxheight = {
        --             description = [[The max height of preview window]],
        --             default = 20,
        --         },
        --     },
        --     mappings = {
        --         description = [[The table for {function = key}]],
        --         default = [[see ###Preview function table for detail]],
        --     },
        -- },
        -- config = function(_, opts)
        --     local handler =            opts['fold_virt_text_handler'] = handler
        --     require('ufo').setup(opts)
        --     -- vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
        --     -- vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
        --     -- vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds)
        --     vim.keymap.set('n', 'K', function()
        --         local winid = require('ufo').peekFoldedLinesUnderCursor()
        --         if not winid then
        --             -- vim.lsp.buf.hover()
        --             vim.cmd [[ Lspsaga hover_doc ]]
        --         end
        --     end)
        -- end,
    },
}
