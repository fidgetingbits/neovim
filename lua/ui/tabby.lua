return {
  'tabby.nvim',
  lazy = false,
  after = function(plugin)
    require('tabby').setup({})
    -- FIXME:I think we want to append tabpages and globals, and keep the rest to the defaults
    vim.opt.sessionoptions = 'curdir,folds,globals,help,tabpages,terminal,winsize'
  end,
}
