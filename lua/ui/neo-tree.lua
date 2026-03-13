return {
  {
    'neo-tree.nvim',
    event = 'DeferredUIEnter',
    after = function(plugin)
      require('neo-tree').setup({
        event_handlers = {
          {
            event = 'neo_tree_buffer_enter',
            handler = function(arg)
              vim.opt.relativenumber = true
            end,
          },
        },
      })
      vim.keymap.set(
        'n',
        '<leader>n',
        ':Neotree toggle current reveal_force_cwd<CR>',
        { desc = 'Toggle Neotree' }
      )
    end,
  },
}
