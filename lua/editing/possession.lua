-- Why possessions? I don't cwd-based sessions.
-- My sessions are often multi-tabbed, multi-project, etc
-- Also supports renaming, built-in telescope picker
return {
  'possession',
  lazy = false,
  after = function()
    p = require('possession')
    -- stylua: ignore start
    p.setup({})
    vim.keymap.set('n', '<leader>ps', vim.cmd.PossessionSave,   { desc = 'Save session' })
    vim.keymap.set('n', '<leader>pl', vim.cmd.PossessionLoad,   { desc = 'Load session' })
    vim.keymap.set('n', '<leader>pr', vim.cmd.PossessionRename, { desc = 'Rename session' })
    vim.keymap.set('n', '<leader>px', vim.cmd.PossessionClose,  { desc = 'Close session' })
    vim.keymap.set('n', '<leader>pp', vim.cmd.PossessionPick,   { desc = 'Pick session' })
    -- TODO: Verify this prompts for confirmation, otherwise probably don't bind to avoid fat finger
    vim.keymap.set('n', '<leader>pd', vim.cmd.PossessionDelete, { desc = 'Delete session' })
    vim.keymap.set('n', '<leader>pS', vim.cmd.PossessionShow,   { desc = 'Show session' })
    --
    -- vim.keymap.set('n', '<leader>pS', function() p.select() end, { desc = 'Select Session' })
    -- vim.keymap.set('n', '<leader>pl', function() p.load({ last = true }) end, { desc = 'Load last session' })
    -- vim.keymap.set('n', '<leader>pd', function() p.stop() end, { desc = 'Stop Session' })

    -- save_cwd = 'PossessionSaveCwd',
    -- load_cwd = 'PossessionLoadCwd',
    -- show = 'PossessionShow',
    -- pick = 'PossessionPick',
    -- list = 'PossessionList',
    -- list_cwd = 'PossessionListCwd',
    -- migrate = 'PossessionMigrate',
    -- stylua: ignore stop
  end,
}
