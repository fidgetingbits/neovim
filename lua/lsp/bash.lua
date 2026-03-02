return {
  {
    "bashls",
    lsp = {
      -- Add .zsh files as there is no dedicated zsh lsp afaik
      filetypes = { 'bash', 'sh', 'zsh' },
      root_markers = { ".git", ".zshrc", ".bashrc", ".envrc" },
      single_file_support = true,
      settings = {
        -- Default globPattern isn't recursive
        -- This encourages use of GLOB_PATTERN in a .env file I guess?
        -- vim.env.GLOB_PATTERN or '*@(.sh|.inc|.bash|.command)',
        -- https://github.com/neovim/nvim-lspconfig/blob/1f7fbc34e6420476142b5cc85e9bee52717540fb/lsp/bashls.lua#L4
        -- FIXME: Disable this if it becomes problematic
        bashIde = {
          globPattern = '**/*@(.sh|.inc|.bash|.command)',
        },
        bashls = {}
      }
    },
  },
}
