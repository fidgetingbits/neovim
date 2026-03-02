return {
  {
    "wilder.nvim",
    auto_enable = true,
    event = "DeferredUIEnter",
    after = function(plugin)
      local wilder = require('wilder')

      wilder.setup({
        modes = { ':', '/', '?' }
      })
    end
  }
}
