function load_snippets()
  local config_dir = nixInfo(false, 'settings', 'config_directory')
  require('luasnip.loaders.from_vscode').load({
    paths = config_dir .. '/snippets/vscode',
  })
  require('luasnip.loaders.from_lua').load({
    paths = config_dir .. '/snippets/luasnip',
  })
end

return {
  {
    -- NOTE: See blink for keymap
    'luasnip',
    dep_of = { 'blink.cmp' },
    after = function(_)
      local ls = require('luasnip')

      ls.config.setup({
        -- Keeps the last snippet around, so you can jump back in if needed
        history = true,
        -- Updates as you type
        updateevents = 'TextChanged,TextChangedI',
        -- Deletes choice node floating text after leaving snippet
        -- NOTE: has perf cost https://github.com/L3MON4D3/LuaSnip/issues/298
        delete_check_events = 'TextChanged,CursorMoved',

        -- Add choice node indicator
        ext_opts = {
          [require('luasnip.util.types').choiceNode] = {
            active = {
              virt_text = { { ' ← Choice ', 'ErrorMsg' } },
            },
          },
        },
      })

      -- Load friendly-snippets
      require('luasnip.loaders.from_vscode').lazy_load()

      -- Load snipmate snippets (NOTE: lots of duplicates)
      --
      -- snipmate globals use '_' identifier for all
      -- ls.filetype_extend('all', { '_' })
      -- require('luasnip.loaders.from_snipmate').lazy_load()

      load_snippets()

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

      vim.keymap.set({ 'i', 's' }, '<C-f>', function()
        if ls.choice_active() then
          require('luasnip.extras.select_choice')()
        end
      end, { desc = 'Select luasnip choice' })

      vim.api.nvim_create_user_command(
        'ReloadSnippets',
        load_snippets,
        { desc = '(Re)Loads luasnip snippets' }
      )
    end,
  },
  {
    'friendly-snippets',
    lazy = true,
    dep_of = { 'luasnip' },
  },
  {
    'vim-snippets',
    lazy = true,
    dep_of = { 'luasnip' },
  },
}
