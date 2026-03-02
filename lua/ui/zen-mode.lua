return {
  {
    "zen-mode.nvim",
    event = "DeferredUIEnter",
    after = function(plugin)
      require('zen-mode').setup()
      vim.keymap.set("n", "<leader>zz", ":ZenMode<CR>", { desc = 'Toggle zen mode' })
    end
  },
}
