return {
  'toggleterm.nvim',
  after = function()
    require('toggleterm').setup({
      hide_numbers = false, -- I want to control this myself
      shade_terminals = false, -- Works on open, and then disappears on refocus
    })
    vim.o.hidden = true
  end,
}
