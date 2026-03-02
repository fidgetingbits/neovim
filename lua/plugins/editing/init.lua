return {
  { import = "plugins.editing.mini-ai" },
  { import = "plugins.editing.todo-comments" },
  { import = "plugins.editing.undotree" },
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
    for_cat = 'general.always',
    event = "DeferredUIEnter",
    -- keys = "",
    after = function(plugin)
      require('nvim-surround').setup()
    end,
  },
}
