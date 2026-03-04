return {
  {
    "hardtime.nvim",
    event = "DeferredUIEnter",
    after = function(plugin)
      require("hardtime").setup({})
    end
  },
}
