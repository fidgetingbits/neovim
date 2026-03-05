return {
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
          },
          telemetry = { enabled = false },
          workspace = {
            -- Don't want to always parse nix build result folder
            ignoreDir = { 'result' },
          },
        },
      },
    },
  },
}
