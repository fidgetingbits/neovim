return {
  {
    'neogit',
    event = 'DeferredUIEnter',
    keys = {
      { '<leader>gg', vim.cmd.Neogit, mode = { 'n' }, desc = 'Toggle neogit buffer' },
    },
    after = function(plugin)
      require('neogit').setup({})
    end,
  },
}
