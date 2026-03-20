return {
  'typos-lsp',
  lsp = {
    settings = {
      init_options = { diagnosticSeverity = 'Hint' },
      root_markers = {
        'typos.toml',
        '_typos.toml',
        '.typos.toml',
        '.git',
      },
    },
  },
}
