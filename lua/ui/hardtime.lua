return {
  {
    'hardtime.nvim',
    event = 'DeferredUIEnter',
    after = function(plugin)
      require('hardtime').setup({
        disabled_keys = {
          -- Allows mouse scroll and I use meta+hjkl for movement in insert
          ['<Up>'] = false,
          ['<Down>'] = false,
          ['<Left>'] = false,
          ['<Right>'] = false,
        },
      })
    end,
  },
}
