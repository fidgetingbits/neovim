return {
  {
    'neogit',
    event = 'DeferredUIEnter',
    keys = {
      { '<leader>gG', vim.cmd.Neogit, mode = { 'n' }, desc = 'Toggle neogit buffer' },
      {
        '<leader>gg',
        function()
          require('neogit').open({ kind = 'split' })
        end,
        mode = { 'n', 'x' },
        desc = 'Open neogit in split',
      },
    },
    after = function(plugin)
      require('neogit').setup({})
    end,
  },
}
