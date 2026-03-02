return {
  {
    "luasnip",
    dep_of = { "blink.cmp" },
    after = function(_)
      local luasnip = require 'luasnip'
      require('luasnip.loaders.from_vscode').lazy_load()
      luasnip.config.setup {
        -- Keeps the last snippet around, so you can jump back in if needed
        history = true,
        -- Updates as you type
        updateevents = "TextChanged,TextChangedI",
      }

      -- FIXME: Move this to keys
      local ls = require('luasnip')

      -- Prefer not to use tab for completions
      vim.keymap.set({ "i", "s" }, "<c-k>", function()
        if ls.expand_or_jumpable() then
          ls.expand_or_jump()
        end
      end, { silent = true })
      vim.keymap.set({ "i", "s" }, "<c-j>", function()
        if ls.jumpable(-1) then
          ls.jump(-1)
        end
      end, { silent = true })
      vim.keymap.set({ "i", "s" }, "<c-l>", function()
        if ls.choice_active() then
          ls.change_choice(1)
        end
      end, { silent = true })
      -- reload snippets
      -- FIXME: Figure out what path to use to reload snippets from neovim wrapper
      vim.keymap.set("n", "<leader><leader>ls", "<cmd>source ~/...<CR>")
    end,
  },
}
