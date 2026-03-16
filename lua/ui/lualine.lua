return {
  {
    'lualine.nvim',
    event = 'DeferredUIEnter',
    after = function(_)
      require('lualine').setup({
        options = {
          icons_enabled = false,
          component_separators = '|',
          section_separators = '',
        },
        sections = {
          lualine_c = {
            {
              function()
                return vim.b.term_name or vim.b.term_title or vim.fn.expand('%:t')
              end,
              cond = function()
                return vim.bo.buftype == 'terminal'
              end,
            },
            {
              'filename',
              path = 1,
              status = true,
              cond = function()
                return vim.bo.buftype ~= 'terminal'
              end,
            },
          },
        },
        inactive_sections = {
          lualine_b = {
            {
              'filename',
              path = 3,
              status = true,
            },
          },
          lualine_x = { 'filetype' },
        },
        tabline = {}, -- Managed by tabby.nvim
      })
    end,
  },
}
