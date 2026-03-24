return {
  {
    -- 'zen-mode.nvim',
    'zen-mode',
    event = 'DeferredUIEnter',
    after = function(plugin)
      require('zen-mode').setup()
      vim.keymap.set('n', '<leader>zz', vim.cmd.ZenMode, { desc = 'Toggle zen mode' })
    end,
  },
}
