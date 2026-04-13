local MP = ...
return {
  { import = MP:relpath('undotree') },
  {
    'indent-blankline.nvim',
    event = 'DeferredUIEnter',
    after = function(plugin)
      require('ibl').setup()
    end,
  },
}
