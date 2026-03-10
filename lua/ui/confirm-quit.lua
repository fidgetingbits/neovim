return {
  {
    'confirm-quit',
    enabled = nixInfo(false, 'settings', 'neovide'),
    after = function()
      local cq = require('confirm-quit')
      cq.setup()
      local function save_and_quit()
        vim.cmd('w')
        cq.confirm_quit()
      end
      vim.opt.confirm = true
      vim.api.nvim_create_user_command('Wq', save_and_quit, {})
      vim.api.nvim_create_user_command('WQ', save_and_quit, {})
      vim.api.nvim_create_user_command('Q', cq.confirm_quit, {})
    end,
  },
}
