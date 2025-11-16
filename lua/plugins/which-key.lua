local function convert_to_new_format(keymaps, prefix)
    local mappings = {}

    for key, value in pairs(keymaps) do
        local full_key = prefix .. key

        if type(value) == 'table' then
            if value.name then
                table.insert(mappings, { full_key, group = value.name, nowait = true, remap = false })
                -- Continue recursively for sub-mappings
                for sub_key, sub_value in pairs(value) do
                    if sub_key ~= 'name' then
                        local sub_mappings = convert_to_new_format({ [sub_key] = sub_value }, full_key)
                        for _, sub_mapping in ipairs(sub_mappings) do
                            table.insert(mappings, sub_mapping)
                        end
                    end
                end
            else
                if type(value[1]) == 'function' or type(value[1]) == 'string' then
                    table.insert(mappings, { full_key, value[1], desc = value[2], nowait = true, remap = false })
                else
                    local sub_mappings = convert_to_new_format(value, full_key)
                    for _, sub_mapping in ipairs(sub_mappings) do
                        table.insert(mappings, sub_mapping)
                    end
                end
            end
        end
    end

    return mappings
end

-- local which_key_mappings = convert_to_new_format(leader_keymaps.normal_mode, '<leader>')
-- Print or use the `which_key_mappings` as needed
-- print(vim.inspect(which_key_mappings))

return {                -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VeryLazy', -- Defer loading until startup is complete
    priority = 100,
    config = function() -- This is the function that runs, AFTER loading
        local wk = require 'which-key'
        local which_key_mappings = (require 'keymaps.keymaps').which_key_mappings
        -- Document existing key chains using pages
        wk.add(which_key_mappings.pages.normal_mode)
        wk.add(which_key_mappings.pages.visual_mode)

        wk.add(convert_to_new_format(which_key_mappings.normal_mode, '<leader>'))
        wk.add(convert_to_new_format(which_key_mappings.visual_mode, '<leader>'))
        -- wk.add(convert_to_new_format(which_key_mappings.visual_mode, '<leader>'))
    end,
}

--   { "<leader>D", group = "DAP", nowait = true, remap = false },
--   { "<leader>D0", <function 1>, desc = "Restart", nowait = true, remap = false },
--   { "<leader>D1", <function 1>, desc = "Continue", nowait = true, remap = false },
--   { "<leader>D2", <function 1>, desc = "Step Into", nowait = true, remap = false },
--   { "<leader>D3", <function 1>, desc = "Step Over", nowait = true, remap = false },
--   { "<leader>D4", <function 1>, desc = "Step Out", nowait = true, remap = false },
--   { "<leader>D5", <function 1>, desc = "Step Back", nowait = true, remap = false },
--   { "<leader>DPt", <function 1>, desc = "Test Method", nowait = true, remap = false },
--   { "<leader>Db", <function 1>, desc = "Toggle Breakpoint", nowait = true, remap = false },
--   { "<leader>De", <function 1>, desc = "Evaluate", nowait = true, remap = false },
--   { "<leader>Dr", group = "Run", nowait = true, remap = false },
--   { "<leader>Drb", <function 1>, desc = "Run To Cursor", nowait = true, remap = false },
--   { "<leader>E", group = "Explorer Functions", nowait = true, remap = false },
--   { "<leader>E?", <function 1>, desc = "Help", nowait = true, remap = false },
--   { "<leader>Ep", <function 1>, desc = "Root To Parent", nowait = true, remap = false },
--   { "<leader>F", "<cmd>Telescope file_browser<CR>", desc = "File Browser", nowait = true, remap = false },
--   { "<leader>GG", ":Gen<CR>", desc = "Gen Options", nowait = true, remap = false },
--   { "<leader>Ga", ":Gen Ask<CR>", desc = "Ask", nowait = true, remap = false },
--   { "<leader>Gc", ":Gen Chat<CR>", desc = "Chat", nowait = true, remap = false },
--   { "<leader>Gs", ":Gen Enhance_Grammar_Spelling<CR>", desc = "Spelling", nowait = true, remap = false },
--   { "<leader>P", group = "Python", nowait = true, remap = false },
--   { "<leader>Pv", "<cmd>VenvSelect<cr>", desc = "Select Environment", nowait = true, remap = false },
--   { "<leader>ca", <function 1>, desc = "Action", nowait = true, remap = false },
--   { "<leader>cr", <function 1>, desc = "Rename", nowait = true, remap = false },
--   { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Explorer", nowait = true, remap = false },
--   { "<leader>g", group = "Git", nowait = true, remap = false },
--   { "<leader>gC", "<cmd>Telescope git_bcommits<cr>", desc = "Checkout commit(for current file)", nowait = true, remap = false },
--   { "<leader>gR", "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", desc = "Reset Buffer", nowait = true, remap = false },
--   { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Checkout branch", nowait = true, remap = false },
--   { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Checkout commit", nowait = true, remap = false },
--   { "<leader>gd", "<cmd>Gitsigns diffthis HEAD<cr>", desc = "Git Diff", nowait = true, remap = false },
--   { "<leader>gg", "<cmd>lua require 'plugins.terminal'.lazygit_toggle()<cr>", desc = "Lazygit", nowait = true, remap = false },
--   { "<leader>gj", "<cmd>lua require 'gitsigns'.next_hunk({navigation_message = false})<cr>", desc = "Next Hunk", nowait = true, remap = false },
--   { "<leader>gk", "<cmd>lua require 'gitsigns'.prev_hunk({navigation_message = false})<cr>", desc = "Prev Hunk", nowait = true, remap = false },
--   { "<leader>gl", "<cmd>lua require 'gitsigns'.blame_line()<cr>", desc = "Blame", nowait = true, remap = false },
--   { "<leader>go", "<cmd>Telescope git_status<cr>", desc = "Open changed file", nowait = true, remap = false },
--   { "<leader>gp", "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", desc = "Preview Hunk", nowait = true, remap = false },
--   { "<leader>gr", "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", desc = "Reset Hunk", nowait = true, remap = false },
--   { "<leader>gs", "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", desc = "Stage Hunk", nowait = true, remap = false },
--   { "<leader>gu", "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>", desc = "Undo Stage Hunk", nowait = true, remap = false },
--   { "<leader>j", group = "Jump", nowait = true, remap = false },
--   { "<leader>jJ", <function 1>, desc = "Semantic Jump", nowait = true, remap = false },
--   { "<leader>jR", <function 1>, desc = "Treesitter Search", nowait = true, remap = false },
--   { "<leader>jj", <function 1>, desc = "Jump", nowait = true, remap = false },
--   { "<leader>jr", <function 1>, desc = "Remote Flash", nowait = true, remap = false },
--   { "<leader>jt", <function 1>, desc = "Toggle Flash Search", nowait = true, remap = false },
--   { "<leader>s", group = "Search", nowait = true, remap = false },
--   { "<leader>s.", <function 1>, desc = "Resume", nowait = true, remap = false },
--   { "<leader>s/", <function 1>, desc = "/ in Open Files", nowait = true, remap = false },
--   { "<leader>sb", <function 1>, desc = "Find existing buffers", nowait = true, remap = false },
--   { "<leader>sd", <function 1>, desc = "Diagnostics", nowait = true, remap = false },
--   { "<leader>sf", <function 1>, desc = "Files", nowait = true, remap = false },
--   { "<leader>sg", <function 1>, desc = "Grep", nowait = true, remap = false },
--   { "<leader>sh", <function 1>, desc = "Help", nowait = true, remap = false },
--   { "<leader>sk", <function 1>, desc = "Keymaps", nowait = true, remap = false },
--   { "<leader>sn", <function 1>, desc = "Neovim files", nowait = true, remap = false },
--   { "<leader>sr", <function 1>, desc = 'Recent Files ("." for repeat)', nowait = true, remap = false },
--   { "<leader>ss", <function 1>, desc = "Search Types Telescope", nowait = true, remap = false },
--   { "<leader>sw", <function 1>, desc = "current Word", nowait = true, remap = false },
--   { "<leader>th", <function 1>, desc = "[T]oggle Inlay [H]ints", nowait = true, remap = false },
-- }
