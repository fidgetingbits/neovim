return {
  {
    -- Better in and around targeting that includes treesitter support. Replaces nvim-treesitter-textobjects
    'mini.ai',
    event = 'DeferredUIEnter',
    after = function(plugin)
      require('mini.ai').setup()
    end,
  },
}
