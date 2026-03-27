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
        tabby = {},
        terminal = {},
        scope = {},
      },
      buf_filter = function(bufnr)
        local buftype = vim.bo[bufnr].buftype
        if buftype == 'help' then
          return true
        end
        if buftype ~= '' and buftype ~= 'acwrite' then
          return false
        end
        if vim.api.nvim_buf_get_name(bufnr) == '' then
          return false
        end

        -- modified to return true by default, as required by scope
        return true
      end,
    })
    
    -- stylua: ignore start
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
