local icons = require 'ui.icons' -- Assuming this require works and provides the icons

-- Define signs for nvim-dap (or similar debugger plugin)
-- These are NOT diagnostic signs, so using vim.fn.sign_define here is appropriate
-- and not affected by the deprecation warning for diagnostic signs.
vim.fn.sign_define('DapBreakpoint', { text = icons.ui.Bug, texthl = 'DapBreakpoint' })
vim.fn.sign_define('DapBreakpointCondition', { text = icons.ui.Bug, texthl = 'DapBreakpoint' })
vim.fn.sign_define('DapBreakpointRejected', { text = icons.ui.BoldArrowRight, texthl = 'DapBreakpoint' })
vim.fn.sign_define('DapLogPoint', { text = icons.ui.Comment, texthl = 'DapLogPoint' })
vim.fn.sign_define('DapStopped', { text = icons.ui.Triangle, texthl = 'DapStopped' })

-- Define diagnostic signs using the recommended vim.diagnostic.config
-- Define the icons for different severity levels
local diagnostic_icons = {
    Error = icons.diagnostics and icons.diagnostics.Error or '✘', -- Use icons from your ui module or fallback
    Warn = icons.diagnostics and icons.diagnostics.Warn or '▲',
    Hint = icons.diagnostics and icons.diagnostics.Hint or '⚑',
    Info = icons.diagnostics and icons.diagnostics.Info or '»',
    -- You can add other levels like vim.diagnostic.severity.TRACE if needed
}

-- Prepare the configuration table for vim.diagnostic.config
local diagnostic_config_signs = {}
for severity, icon in pairs(diagnostic_icons) do
    local highlight_group = 'DiagnosticSign' .. severity
    -- The key in the 'signs' table corresponds to the severity name (e.g., "Error", "Warn")
    diagnostic_config_signs[severity] = {
        text = icon,
        texthl = highlight_group,
        numhl = highlight_group, -- Highlight the line number with the same group
        -- linehl = '', -- Optional: Highlight the whole line
        -- priority = 10, -- Optional: Set sign priority
    }
end

-- Apply the sign configuration using vim.diagnostic.config
vim.diagnostic.config {
    signs = diagnostic_config_signs,
    -- You can configure other diagnostic options here as well, for example:
    virtual_text = true,
    -- underline = true,
    -- update_in_insert = false,
    -- severity_sort = true,
}
