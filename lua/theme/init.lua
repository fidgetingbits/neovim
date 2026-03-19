local MP = ...
return {
  -- Primary colorscheme
  -- FIXME: Rework this so I include them all and just set the colorscheme elsewhere
  { import = MP:relpath('catppuccin') },
  -- { import = MP:relpath('miasma') },

  -- Theming utils
  {
    'lush.nvim',
    after = function()
      require('lush').setup({})
    end,
  },
}
