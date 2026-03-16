local function mode()
  -- FIXME: Tweak these to differentiate the mode
  -- Map of modes to their respective shorthand indicators
  local mode_map = {
    n = 'N', -- Normal mode
    i = 'I', -- Insert mode
    v = 'V', -- Visual mode
    [''] = 'VB', -- Visual block mode
    V = 'VL', -- Visual line mode
    c = 'C', -- Command-line mode
    no = 'N', -- NInsert mode
    s = 'S', -- Select mode
    S = 'SL', -- Select line mode
    ic = 'IC', -- Insert mode (completion)
    R = 'R', -- Replace mode
    Rv = 'RV', -- Virtual Replace mode
    cv = 'C', -- Command-line mode
    ce = 'CE', -- Ex mode
    r = 'P', -- Prompt mode
    rm = 'M', -- More mode
    ['r?'] = '?', -- Confirm mode
    ['!'] = '!', -- Shell mode
    t = 'T', -- Terminal mode
  }
  -- Return the mode shorthand or [UNKNOWN] if no match
  return mode_map[vim.fn.mode()] or '[UNKNOWN]'
end

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
          lualine_a = { { mode } },
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
