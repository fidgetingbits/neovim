return {
  {
    -- Better in and around targeting that includes treesitter support. Replaces
    -- nvim-treesitter-textobjects
    'mini.ai',
    event = 'DeferredUIEnter',
    after = function(plugin)
      local ai = require('mini.ai')
      ai.setup({
        -- Use next/prev to stay consistent with <c-n>/<c-p> for snippet selections
        mappings = {
          around_next = 'an',
          inside_next = 'in',
          around_last = 'ap',
          inside_last = 'ip',
        },
        custom_textobjects = {
          -- This will need nvim-treesitter-textobjects loaded to pre-define these queries
          -- stylua: ignore start
          a = ai.gen_spec.treesitter({ a = '@parameter.outer',   i = '@parameter.inner' }),
          c = ai.gen_spec.treesitter({ a = '@class.outer',       i = '@class.inner' }),
          f = ai.gen_spec.treesitter({ a = '@function.outer',    i = '@function.inner' }),
          i = ai.gen_spec.treesitter({ a = '@conditional.outer', i = '@conditional.inner' }),
          l = ai.gen_spec.treesitter({ a = '@loop.outer',        i = '@loop.inner' }),
          n = ai.gen_spec.treesitter({ a = '@assignment.lhs',    i = '@assignment.lhs' }),
          r = ai.gen_spec.treesitter({ a = '@return.outer',      i = '@return.inner' }),
          t = ai.gen_spec.treesitter({ a = '@comment.outer',     i = '@comment.outer' }),
          v = ai.gen_spec.treesitter({ a = '@assignment.rhs',    i = '@assignment.rhs' }),
          -- stylua: ignore end
        },
      })
    end,
  },
}
