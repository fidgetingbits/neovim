vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

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
  vim.notify('ERROR: This config cannot run without introdus. Use the module-generated wrapper')
end

-- NOTE: See https://codeberg.org/fidgetingbits/introdus/src/branch/aa/wrappers/neovim/
-- for more shared config and plugins

-- Load all the plugins/lsps from lua/
nixInfo.lze.load({
  {
    import = 'ai',
    category = 'ai',
  },
  {
    import = 'completion',
    category = 'completion',
  },
  {
    import = 'editing',
    category = 'editing',
  },
  {
    import = 'format',
    category = 'format',
  },
  {
    import = 'git',
    category = 'git',
  },
  {
    import = 'lsp',
    category = 'lsp',
  },
  {
    import = 'markdown',
    category = 'markdown',
  },
  {
    import = 'search',
    category = 'search',
  },
  {
    import = 'ui',
    category = 'ui',
  },
})
