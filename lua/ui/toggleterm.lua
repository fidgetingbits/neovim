return {
  'toggleterm.nvim',
  enabled = nixInfo(false, 'settings', 'terminalMode'),
  after = function()
    require('toggleterm').setup({
      hide_numbers = false, -- I want to control this myself
      shade_terminals = false, -- Works on open, and then disappears on refocus
      -- FIXME: Tweak the highlights
    })
    vim.o.hidden = true

    -- stylua: ignore start
    vim.keymap.set( { 'n', 'v', 'i', 't' }, '<A-;>', function() vim.cmd('ToggleTerm size=40 direction=float') end, {})
    -- stylua: ignore end
  end,
}
