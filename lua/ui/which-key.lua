return {
  {
    'which-key.nvim',
    event = 'DeferredUIEnter',
    after = function(_)
      require('which-key').setup({
        preset = 'modern',
        delay = 150,
        icons = {
          mappings = true,
          keys = {},
        },
        spec = {
          { '<leader>b', group = '[b]uffer ' },
          { '<leader>c', group = '[c]ode actions' }, -- FIXME: revisit
          { '<leader>i', group = '[i]nverse value' },
          { '<leader>g', group = '[g]it' },
          { '<leader>l', group = '[l]sp' },
          { '<leader>m', group = '[m]arkdown' },
          { '<leader>n', group = '[n]eotree' },
          { '<leader>o', group = '[o]bsidian' },
          { '<leader>u', group = '[u]ndotree' },
          { '<leader>q', group = 'persistence' },
          { '<leader>r', group = '[r]ename' }, -- FIXME: revisit
          { '<leader>s', group = '[s]earch picker' }, -- FIXME: maybe switch to f
          { '<leader>t', group = '[t]oggle settings' },
          { '<leader>x', group = 'quickfi[x] & diagnostics' },
          { '<leader>y', group = '[y]ank' },
          { '<leader>z', group = 'folds/zen' },
          { '<leader>F', group = '[F]ormatting' },
          { '<leader><tab>', group = 'tabs' },
        },
      })
    end,
  },
}
