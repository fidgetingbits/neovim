return {
  "catppuccin/nvim",
  name = "catppuccin-nvim", -- required for nixcats to recognize
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd([[colorscheme catppuccin]])
    -- vim.cmd("highlight WinSeparator guifg=#EDC4E5 guibg=#171720")

    require("catppuccin").setup({
      --transparent_background = true,
      integrations = {
        cmp = true,
        gitsigns = true,
        neotree = true,
        notify = true,
        treesitter = true,
        barbar = true,
        ufo = true,
        which_key = true,
        leap = true,
      },
    })
  end,
}
