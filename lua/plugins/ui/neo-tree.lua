return {
  {
    "neo-tree.nvim",
    event = "DeferredUIEnter",
    after = function(plugin)
      require('neo-tree').setup({})
      vim.keymap.set("n", "<leader>n", ":Neotree toggle<CR>", { desc = "Toggle Neotree" })
    end
  },
}
