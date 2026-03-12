return {
  -- FIXME: revisit the git branch flag, as not so sure it's useful
  -- Also need to figure out how cwd tie in works with tab-based workspaces
  -- Compare against auto-session and persisted.nvim (persistence.nvim fork)
  'persistence.nvim',
  after = function()
    p = require('persistence')
    -- stylua: ignore start
    require('persistence').setup()
    vim.keymap.set('n', '<leader>qs', function() p.load() end, { desc = 'Load Session for CWD' })
    vim.keymap.set('n', '<leader>qS', function() p.select() end, { desc = 'Select Session' })
    vim.keymap.set('n', '<leader>ql', function() p.load({ last = true }) end, { desc = 'Load last session' })
    vim.keymap.set('n', '<leader>qd', function() p.stop() end, { desc = 'Stop Session' })
    -- stylua: ignore stop
  end,
}
