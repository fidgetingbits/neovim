local MP = ...
return {
  -- { import = MP:relpath('confirm-quit') },
  { import = MP:relpath('hardtime') },
  { import = MP:relpath('lualine') },
  { import = MP:relpath('lua-console') },
  { import = MP:relpath('neo-tree') },
  -- { import = MP:relpath('noice') },
  { import = MP:relpath('notifications') },
  -- { import = MP:relpath('smart-splits') },
  { import = MP:relpath('snacks') },
  { import = MP:relpath('tabby') },
  { import = MP:relpath('toggleterm') },
  { import = MP:relpath('trouble') },
  { import = MP:relpath('which-key') },
  -- { import = MP:relpath('zen-mode') },
  {
    'ansi',
    lazy = false,
    after = function()
      require('ansi').setup({})
    end,
  },
}
