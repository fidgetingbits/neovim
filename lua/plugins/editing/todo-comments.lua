return {
  {
    "todo-comments.nvim",
    auto_enable = true,
    event = { "BufReadPost", "BufNewFile" },
    after = function(name)
      require("todo-comments").setup({
        signs = true, -- show icons in sign column
        keywords = {
          FIX = {
            icon = " ",
            color = "error",
            alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
          },
          TODO = { icon = "", color = "info" },
          HACK = { icon = "", color = "warning" },
          WARN = { icon = "", color = "warning", alt = { "WARNING", "XXX" } },
          PERF = { icon = "⚡", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
          NOTE = { icon = "", color = "hint", alt = { "INFO" } },
          TEST = { icon = "", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
        },
        -- patterns from: https://github.com/folke/todo-comments.nvim/issues/10
        search = {
          pattern = [[\b(KEYWORDS)(\([^\)]*\))?:]]
        },
        highlight = {
          pattern = [[.*<((KEYWORDS)%(\(.{-1,}\))?):]]
        },
      })
    end,
  }
}
