return {
  { import = 'editing.mini-ai' },
  { import = 'editing.nvim-toggler' },
  { import = 'editing.resession' },
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
    after = function(plugin)
      require('mini.surround').setup({
        -- flash.nvim uses s/S, so we use m (and remap m to <leader> m)
        -- Think of m like matching (since surrounding chars are matched)
        mappings = {
          add = 'ma', -- Add surrounding in Normal and Visual modes
          delete = 'md', -- Delete surrounding
          find = 'mf', -- Find surrounding (to the right)
          find_left = 'mF', -- Find surrounding (to the left)
          highlight = 'mh', -- Highlight surrounding
          replace = 'mr', -- Replace surrounding
        },
      })
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
