return {
  {
    -- NOTE: See blink for keymap
    'luasnip',
    dep_of = { 'blink.cmp' },
    after = function(_)
      local luasnip = require('luasnip')
      require('luasnip.loaders.from_vscode').lazy_load()
      luasnip.config.setup({
        -- Keeps the last snippet around, so you can jump back in if needed
        history = true,
        -- Updates as you type
        updateevents = 'TextChanged,TextChangedI',
      })

      local ls = require('luasnip')

      vim.keymap.set({ 'i', 's' }, '<c-k>', function()
        if ls.expand_or_jumpable() then
          ls.expand_or_jump()
        end
      end, { silent = true })

      vim.keymap.set({ 'i', 's' }, '<c-j>', function()
        if ls.jumpable(-1) then
          ls.jump(-1)
        end
      end, { silent = true })

      vim.keymap.set({ 'i', 's' }, '<c-l>', function()
        if ls.choice_active() then
          ls.change_choice(1)
        end
      end, { silent = true })
    end,
  },
  {
    'friendly-snippets',
    dep_of = { 'luasnip' },
  },
}
