return {
  'typos-lsp',
  lsp = {
    init_options = { diagnosticSeverity = 'Hint' },
    root_markers = {
      'typos.toml',
      '_typos.toml',
      '.typos.toml',
      '.git',
    },
    settings = {},
  },
}
