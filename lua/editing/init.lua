return {
  { import = "editing.mini-ai" },
  { import = "editing.todo-comments" },
  { import = "editing.undotree" },
  -- FIXME: Move to modules
  {
    "indent-blankline.nvim",
    event = "DeferredUIEnter",
    after = function(plugin)
      require("ibl").setup()
    end,
  },
  -- FIXME: Maybe replace with mini-comment?
  {
    "comment.nvim",
    event = "DeferredUIEnter",
    after = function(plugin)
      require('Comment').setup()
    end,
  },
  -- FIXME: Probably replace with mini-surround?
  {
    "nvim-surround",
    event = "DeferredUIEnter",
    -- keys = "",
    after = function(plugin)
      require('nvim-surround').setup()
    end,
  },
  {
    "cutlass.nvim",
    lazy = false,
    after = function(plugin)
      require('cutlass').setup({
        cut_key = 'x',
      })
    end,
  },
}
