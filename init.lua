-- MP + relpath() trick explained in introdus repo
-- Not set to ... here because base init.lua isn't passed an arg

local MP = ''
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.colorscheme = 'catppuccin'
-- vim.g.colorscheme = 'miasma'

-- This config is derived from the introdus neovim wrapper
-- so have introdus set things up for us
local introdus_config = os.getenv('NVIM_BASE_CONFIG')
if introdus_config then
  -- Prepend so B's lua/ directory is searchable immediately
  vim.opt.rtp:prepend(introdus_config)

  -- Prepend to packpath so B's plugins (if any) are found
  vim.opt.packpath:prepend(introdus_config)

  -- Handle the 'after' directory correctly
  local introdus_after = introdus_config .. '/after'
  if vim.fn.isdirectory(introdus_after) == 1 then
    vim.opt.rtp:append(introdus_after)
  end
  require('introdus')
else
  print([[ERROR: This config cannot run without introdus. 
      Use settings.extraConfig in your wrapper to specify the introdus path]])
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
