return {
  'tabby.nvim',
  lazy = false,
  after = function(plugin)
    require('tabby').setup({})
  end,
}
