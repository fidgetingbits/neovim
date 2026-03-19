return {
  'miasma.nvim',
  lazy = false,
  priority = 1000,
  after = function(plugin)
    vim.cmd.colorscheme('miasma')
  end,
}
