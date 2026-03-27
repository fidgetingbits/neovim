return {
  'scope.nvim',
  lazy = false,
  after = function()
    require('scope').setup({})
  end,
}
