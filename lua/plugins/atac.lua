local atac_tmp_dir = '/tmp/atac/'

if IS_WINDOWS then
    atac_tmp_dir = '~\\AppData\\Local\\Temp\\atac'
end

return {
    'NachoNievaG/atac.nvim',
    dependencies = { 'akinsho/toggleterm.nvim' },
    config = function()
        require('atac').setup {
            dir = atac_tmp_dir,
        }
    end,
}
