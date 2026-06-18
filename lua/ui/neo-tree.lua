return {
  {
    'neo-tree.nvim',
    event = 'DeferredUIEnter',
    after = function(plugin)
      require('neo-tree').setup({
        event_handlers = {
          {
            event = 'neo_tree_buffer_enter',
            handler = function(_)
              vim.opt.relativenumber = true
            end,
          },
        },
        filesystem = {
          filtered_items = {
            -- Don't bother parsing lock files
            never_show_by_pattern = { 'locks/*.lock' },
          },
        },
      })
      vim.keymap.set(
        'n',
        '<leader>n',
        ':Neotree toggle reveal_force_cwd<CR>',
        { desc = 'Toggle Neotree' }
      )
    end,
  },
}
