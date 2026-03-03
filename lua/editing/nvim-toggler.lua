return {
  {
    "nvim-toggler",
    lazy = false,
    after = function(plugin)
      require('nvim-toggler').setup()
    end,
  },
}
