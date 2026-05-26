return {
  'neov-ime',
  event = 'VimEnter',
  after = function(plugin)
    require('neov-ime').setup()
  end,
}
