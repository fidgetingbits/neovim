local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

return {
  {
    'jsonls',
    lsp = {
      settings = {
        json = {
          schemas = require('schemastore').json.schemas(),
          validate = { enable = true },
          -- Needed for completions apparently?
          capabilities = capabilities,
        },
      },
    },
  },
}
