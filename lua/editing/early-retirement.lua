return {
  {
    'nvim-early-retirement',
    after = function(_)
      require('early-retirement').setup({})
    end,
  },
}
