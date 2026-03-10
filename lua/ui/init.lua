return {
  -- Primary colorscheme
  { import = 'ui.catppuccin' },

  { import = 'ui.confirm-quit' },
  { import = 'ui.hardtime' },
  { import = 'ui.lualine' },
  { import = 'ui.lua-console' },
  { import = 'ui.neo-tree' },
  { import = 'ui.noice' },
  { import = 'ui.notifications' },
  { import = 'ui.smart-splits' },
  { import = 'ui.snacks' },
  -- { import = 'ui.tabby' },
  { import = 'ui.trouble' },
  { import = 'ui.which-key' },
  { import = 'ui.zen-mode' },
  {
    'taboo',
    after = function()
      vim.opt.sessionoptions:append({ 'globals', 'tabpages' })
    end,
  },
}
