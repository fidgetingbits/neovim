local MP = ...
return {
  { import = MP:relpath('better-n') },
  { import = MP:relpath('undotree') },
  { import = MP:relpath('cutlass') },
  {
    'indent-blankline.nvim',
    event = 'DeferredUIEnter',
    after = function(plugin)
      require('ibl').setup()
    end,
  },
}
