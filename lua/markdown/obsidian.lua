return {
  {
    "obsidian.nvim",
    event = "DeferredUIEnter",
    after = function(plugin)
      require('obsidian').setup({
        legacy_commands = false,
        disable_metadata = true,
        workspaces = {
          {
            name = "personal",
            path = "~/wiki/",
          },
        },
      })
      vim.keymap.set("n", "<leader>ot", require("obsidian").util.toggle_checkbox(),
        { desc = '[O]bsidian [T]oggle checkbox' })
    end
  },
}
