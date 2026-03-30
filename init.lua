-- MP + relpath() trick explained in introdus repo
-- Not set to ... here because base init.lua isn't passed an arg

local MP = ''
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.colorscheme = 'catppuccin'
-- vim.g.colorscheme = 'miasma'

-- In order to keep our folders clean, we add runtime folders to allow luasnip
-- to find our snippets lazily.
vim.opt.runtimepath:prepend(vim.fn.fnamemodify('./snippets', ':p'))
vim.opt.runtimepath:prepend(vim.fn.fnamemodify('./snippets/vscode', ':p'))

-- This config is derived from the introdus neovim wrapper
-- so have introdus set things up for us
local introdus_config = os.getenv('NVIM_BASE_CONFIG')
if introdus_config then
  vim.opt.runtimepath:prepend(introdus_config)
  require('introdus')
else
  print([[ERROR: This config cannot run without introdus. 
      Use settings.baseConfig in your wrapper to specify the introdus path]])
end

-- NOTE: See https://codeberg.org/fidgetingbits/introdus/src/branch/aa/wrappers/neovim/
-- for more shared config and plugins

-- Load all the plugins/lsps from lua/
nixInfo.lze.load({
  {
    import = MP:relpath('ai'),
    category = 'ai',
  },
  {
    import = MP:relpath('completion'),
    category = 'completion',
  },
  {
    import = MP:relpath('editing'),
    category = 'editing',
  },
  {
    import = MP:relpath('format'),
    category = 'format',
  },
  {
    import = MP:relpath('git'),
    category = 'git',
  },
  -- {
  --   import = MP:relpath('lsp'),
  --   category = 'lsp',
  -- },
  {
    import = MP:relpath('markdown'),
    category = 'markdown',
  },
  {
    import = MP:relpath('search'),
    category = 'search',
  },
  {
    import = MP:relpath('theme'),
    category = 'theme',
  },
  {
    import = MP:relpath('ui'),
    category = 'ui',
  },
})
