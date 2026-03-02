return {
  {
    "fidget.nvim",
    event = "LspAttach",
    after = function(plugin)
      require("fidget").setup({})
    end,
  },
}
