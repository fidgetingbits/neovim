local MP = ...
return {
  { import = MP:relpath('undotree') },
  { import = MP:relpath('early-retirement') },
  {
    'indent-blankline.nvim',
    event = 'DeferredUIEnter',
    after = function(plugin)
      require('ibl').setup()
    end,
  },
}
