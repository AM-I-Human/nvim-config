local icons = require 'ui.icons'
vim.fn.sign_define('DapBreakpoint', { text = icons.ui.Bug, texthl = 'DapBreakpoint' })
vim.fn.sign_define('DapBreakpointCondition', { text = icons.ui.Bug, texthl = 'DapBreakpoint' })
vim.fn.sign_define('DapBreakpointRejected', { text = icons.ui.BoldArrowRight, texthl = 'DapBreakpoint' })
vim.fn.sign_define('DapLogPoint', { text = icons.ui.Comment, texthl = 'DapLogPoint' })
vim.fn.sign_define('DapStopped', { text = icons.ui.Triangle, texthl = 'DapStopped' })
