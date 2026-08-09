local MP = ...
return {
  { import = MP:relpath('haunt') },
  { import = MP:relpath('lualine') },
  { import = MP:relpath('lua-console') },
  { import = MP:relpath('marks') },
  { import = MP:relpath('modes') },
  { import = MP:relpath('neo-tree') },
  { import = MP:relpath('neov-ime') },
  { import = MP:relpath('notifications') },
  { import = MP:relpath('snacks') },
  { import = MP:relpath('tabby') },
  { import = MP:relpath('toggleterm') },
  {
    'ansi',
    lazy = false,
    after = function()
      require('ansi').setup({})
    end,
  },
  {
    'nvim-highlight-colors',
    event = 'DeferredUIEnter',
    after = function(plugin)
      require('nvim-highlight-colors').setup({})
    end,
  },
}
