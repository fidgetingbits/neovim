return {
  { import = 'editing.mini-ai' },
  { import = 'editing.todo-comments' },
  { import = 'editing.undotree' },
  { import = 'editing.nvim-toggler' },
  -- FIXME: Move to modules
  {
    'indent-blankline.nvim',
    event = 'DeferredUIEnter',
    after = function(plugin)
      require('ibl').setup()
    end,
  },
  -- FIXME: Maybe replace with mini-comment?
  {
    'comment.nvim',
    event = 'DeferredUIEnter',
    after = function(plugin)
      require('Comment').setup()
    end,
  },
  {
    'mini.surround',
    event = 'DeferredUIEnter',
    -- keys = "",
    after = function(plugin)
      require('mini.surround').setup()
    end,
  },
  {
    'cutlass.nvim',
    lazy = false,
    after = function(plugin)
      require('cutlass').setup({
        cut_key = 'x',
      })
    end,
  },
  {
    'nvim-better-n',
    lazy = false,
    after = function(plugin)
      require('better-n').setup({})
    end,
  },
}
