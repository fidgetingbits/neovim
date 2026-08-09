local MP = ...
return {
  { import = MP:relpath('undotree') },
  { import = MP:relpath('early-retirement') },
  -- FIXME: Re-enable. Messed up on kanagawa
  -- {
  --   'indent-blankline.nvim',
  --   event = 'DeferredUIEnter',
  --   after = function(plugin)
  --     require('ibl').setup()
  --   end,
  -- },
}
