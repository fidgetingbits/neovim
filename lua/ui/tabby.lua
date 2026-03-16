return {
  'tabby.nvim',
  lazy = false,
  after = function(plugin)
    require('tabby').setup({
      preset = 'tab_only',
      lualine_theme = 'catppuccin',
    })
  end,
}
