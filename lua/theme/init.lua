local MP = ...
return {
  { import = MP:relpath(vim.g.colorscheme) },
  -- Theming utils
  {
    'lush.nvim',
  },
}
