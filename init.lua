-- MP + relpath() trick explained in introdus repo
-- Not set to ... here because base init.lua isn't passed an arg

local MP = ''
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.colorscheme = 'catppuccin'
-- vim.g.colorscheme = 'miasma'

-- In order to keep our folders clean, we add runtime folders to allow luasnip
-- to find our snippets lazily.
-- NOTE: These are snippets in addition to the shared introdus ones, so we still
-- keep them here
local path = debug.getinfo(1, 'S').source:gsub('^@', '')
local dir = vim.fn.fnamemodify(path, ':h')
vim.opt.rtp:prepend(dir .. '/snippets/')
vim.opt.rtp:prepend(dir .. '/snippets/vscode')

-- This config is derived from the shared introdus neovim wrapper config
-- so have introdus set things up for us
local introdus_config = os.getenv('NVIM_BASE_CONFIG')
if introdus_config then
  vim.opt.runtimepath:prepend(introdus_config)
  require('introdus')
else
  print([[ERROR: This config cannot run without introdus.
      Use settings.baseConfig in your wrapper to specify the introdus path]])
end

-- Load plugins (from ./lua/) that extend the shared introdus plugins
-- See https://codeberg.org/fidgetingbits/introdus/src/branch/aa/wrappers/neovim/
nixInfo.lze.load({
  {
    import = MP:relpath('ai'),
    category = 'ai',
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
    enabled = nixInfo(false, 'settings', 'devMode'),
    category = 'git',
  },
  {
    import = MP:relpath('lsp'),
    category = 'lsp',
  },
  {
    import = MP:relpath('markdown'),
    category = 'markdown',
  },
  {
    import = MP:relpath('ui'),
    category = 'ui',
  },
})
