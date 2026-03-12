return {
  { import = 'editing.mini-ai' },
  { import = 'editing.nvim-toggler' },
  { import = 'editing.persistence' },
  { import = 'editing.todo-comments' },
  { import = 'editing.undotree' },
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
      local better_n = require('better-n')
      better_n.setup({})
      -- better_n.set('[[', { next = '[[', prev = ']]' })
      better_n.listen('(%d-)%]%]', { next = ']]', prev = '[[', remap = true, expr = true })
    end,
  },
}
