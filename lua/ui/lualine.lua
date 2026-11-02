local function mode()
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
  return mode_map[vim.fn.mode()] or 'U?'
end

local ok, minuet_lualine = pcall(require, 'minuet.lualine')

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
          lualine_x = {
            {
              ok and minuet_lualine or nil,
              -- the follwing is the default configuration
              -- the name displayed in the lualine. Set to "provider", "model" or "both"
              -- display_name = 'both',
              -- separator between provider and model name for option "both"
              -- provider_model_separator = ':',
              -- whether show display_name when no completion requests are active
              -- display_on_idle = false,
            },
            'encoding',
            'fileformat',
            'filetype',
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
