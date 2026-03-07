-- Provides a repl for lua debugging
return {
  {
    'lua-console',
    lazy = true,
    keys = {
      {
        '`',
        function()
          require('lua-console').toggle_console()
        end,
        mode = { 'n' },
        desc = 'Lua-console - toggle',
      },
      {
        '<Leader>`',
        function()
          require('lua-console').toggle_attach()
        end,
        mode = { 'n' },
        desc = 'Lua-console - attach to buffer',
      },
    },
    after = function(_)
      require('lua-console').setup({})
    end,
  },
}
