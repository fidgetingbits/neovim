return {
  'resession.nvim',
  lazy = false,
  after = function()
    local resession = require('resession')
    resession.setup({
      autosave = {
        enabled = true,
        interval = 30,
        notify = false,
      },
      extensions = {
        lualine = {},
        terminal = {},
      },
    })
    
    -- stylua: ignore start
    local r = require('resession')
    vim.keymap.set('n', '<leader>ps', resession.save,   { desc = 'Save session' })
    vim.keymap.set('n', '<leader>pl', resession.load,   { desc = 'Load session' })
    vim.keymap.set('n', '<leader>pd', resession.delete, { desc = 'Delete session' })
    vim.keymap.set('n', '<leader>px', resession.detach, { desc = 'Close session' })
    -- stylua: ignore end

    vim.api.nvim_create_autocmd('VimLeavePre', {
      callback = function()
        -- Always save a special session named "last"
        resession.save('last')
      end,
    })
  end,
}
