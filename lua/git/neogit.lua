return {
  {
    'neogit',
    event = 'DeferredUIEnter',
    -- stylua: ignore
    keys = {
      { '<leader>gg', ':Neogit<CR>', mode = { 'n' }, noremap = true, desc = 'Toggle neogit buffer', },
    },
    after = function(plugin)
      require('neogit').setup({})
    end,
  },
}
