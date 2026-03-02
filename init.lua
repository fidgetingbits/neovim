vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.loader.enable() -- byte code caching

nixInfo.lze.load {
  {
    import = "ai",
    category = "ai"
  },
  {
    import = "completion",
    category = "completion"
  },
  {
    import = "editing",
    category = "editing"
  },
  {
    import = "format",
    category = "format"
  },
  {
    import = "git",
    category = "git"
  },
  {
    import = "lsp",
    category = "lsp"
  },
  {
    import = "markdown",
    category = "markdown"
  },
  {
    import = "search",
    category = "search"
  },
  {
    import = "ui",
    category = "ui"
  },
}
