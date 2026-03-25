local MP = ...
return {
  { import = MP:relpath('better-n') },
  -- { import = MP:relpath('nvim-toggler') },
  -- { import = MP:relpath('resession') },
  -- { import = MP:relpath('todo-comments') },
  -- { import = MP:relpath('treesitter') },
  { import = MP:relpath('undotree') },
  -- { import = MP:relpath('comment') },
  -- { import = MP:relpath('easy-align') },
  -- { import = MP:relpath('mini-ai') },
  -- { import = MP:relpath('mini-surround') },
  { import = MP:relpath('cutlass') },
  {
    'indent-blankline.nvim',
    event = 'DeferredUIEnter',
    after = function(plugin)
      require('ibl').setup()
    end,
  },
}
