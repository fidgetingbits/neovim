return {
  'toggleterm.nvim',
  after = function()
    require('toggleterm').setup()
    vim.o.hidden = true
  end,
}
