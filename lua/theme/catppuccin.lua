return {
  'catppuccin/nvim',
  name = 'catppuccin-nvim', -- required for nixcats to recognize
  lazy = false,
  priority = 1000,
  config = function()
    -- vim.cmd("highlight WinSeparator guifg=#EDC4E5 guibg=#171720")

    require('catppuccin').setup({
      transparent_background = true,
      auto_integrations = true,
      -- FIXME: not sure if auto integration works with lze
      integrations = {
        gitsigns = true,
        neotree = true,
        notify = true,
        treesitter = true,
        ufo = true,
        which_key = true,
      },
    })
  end,
  after = function(plugin)
    vim.cmd.colorscheme('catppuccin')
  end,
}
