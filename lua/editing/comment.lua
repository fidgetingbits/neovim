return {
  {
    'comment.nvim',
    event = 'DeferredUIEnter',
    after = function(plugin)
      require('Comment').setup()
    end,
  },
}
