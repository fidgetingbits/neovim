return {
  'tabby.nvim',
  lazy = false,
  after = function(plugin)
    require('tabby').setup({
      preset = 'tab_only',
    })
  end,
}
