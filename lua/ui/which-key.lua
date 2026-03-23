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
          { '<leader>f', group = '[f]ind' },
          { '<leader>F', group = '[F]ormatting' },
          { '<leader>g', group = '[g]it' },
          { '<leader>i', group = '[i]nverse value' },
          { '<leader>l', group = '[l]sp' },
          { '<leader>m', group = '[m]arkdown' },
          { '<leader>n', group = '[n]eotree' },
          { '<leader>o', group = '[o]bsidian' },
          { '<leader>u', group = '[u]ndotree' },
          { '<leader>s', group = '[s]ession' },
          { '<leader>t', group = '[t]oggle settings' },
          { '<leader>x', group = 'quickfi[x] & diagnostics' },
          { '<leader>y', group = '[y]ank' },
          { '<leader>z', group = 'folds/zen' },
          { '<leader><leader>', group = 'misc' },
        },
      })
    end,
  },
}
