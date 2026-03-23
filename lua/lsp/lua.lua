return {
  -- Lifted from https://github.com/BirdeeHub/birdeevim/blob/fbf665/lua/birdee/LSPs/nixlua.lua
  {
    'lazydev.nvim',
    auto_enable = true,
    cmd = { 'LazyDev' },
    ft = 'lua',
    after = function(_)
      require('lazydev').setup({
        library = {
          {
            words = { 'uv', 'vim%.uv', 'vim%.loop' },
            path = nixInfo('luvit-meta', 'plugins', 'start', 'luvit-meta') .. '/library',
          },
          { words = { 'nixInfo' }, path = nixInfo('', 'info_plugin_path') .. '/lua' },
          {
            words = { 'nixInfo%.lze' },
            path = nixInfo('lze', 'plugins', 'start', 'lze') .. '/lua',
          },
          {
            words = { 'nixInfo%.lze' },
            path = nixInfo('lzextras', 'plugins', 'start', 'lzextras') .. '/lua',
          },
        },
      })
    end,
  },
  {
    'lua_ls',
    lsp = {
      filetypes = { 'lua' },
      settings = {
        Lua = {
          runtime = { version = 'LuaJIT' },
          formatters = {
            ignoreComments = true,
          },
          signatureHelp = { enabled = true },
          -- See per-project .luarc.json for extras
          diagnostics = {
            disable = { 'missing-fields' },
            -- Allow ignoring unused variables prefixed with _ to keep the names around
            unusedLocalExclude = { '_*' },
          },
          telemetry = { enabled = false },
        },
      },
    },
  },
}
