return {
  {
    'hardtime.nvim',
    event = 'DeferredUIEnter',
    after = function(plugin)
      require('hardtime').setup({
        -- I too often scroll code while drinking, etc
        restricted_keys = {
          ['h'] = false,
          ['j'] = false,
          ['k'] = false,
          ['l'] = false,
          ['gj'] = false,
          ['gk'] = false,
        },
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
