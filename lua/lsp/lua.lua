return {
  {
    'lua_ls',
    lsp = {
      filetypes = { 'lua' },

      -- FIXME: How do we add an on_attach function without clobbering the old one?
      -- this destroys the old on_attach
      -- on_attach = function(client, bufnr)
      --   -- Disable the LSP's formatting expression so 'gqgc' works (gwgc also
      --   -- works without this fix)
      --   -- https://vi.stackexchange.com/questions/39200/wrapping-comment-in-visual-mode-not-working-with-gq
      --   vim.bo[bufnr].formatexpr = nil
      -- end,
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
            -- ignoreDir = { 'result' },
          },
        },
      },
    },
  },
}
