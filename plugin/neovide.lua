if vim.g.neovide then
  -- When using rounded borders lualine/tabs clip
  vim.g.neovide_padding_top = 10
  vim.g.neovide_padding_bottom = 10
  vim.g.neovide_padding_right = 10
  vim.g.neovide_padding_left = 10

  local utils = require('utils')
  if vim.g.colors_name == 'catppuccin-mocha' then
    local colors = require('catppuccin.palettes').get_palette('mocha')
    vim.api.nvim_set_hl(0, 'Normal', { bg = colors.base })
    utils.set_cursor_colors(colors)
    utils.set_term_colors(colors)
  end
  vim.g.neovide_cursor_smooth_blink = true

  -- FIXME: This doesn't work
  vim.keymap.set(
    'n',
    '<LeftMouse>',
    '<LeftMouse><cmd>lua vim.api.nvim_set_current_win(vim.fn.getmousepos().winid)<CR>',
    { silent = true }
  )

  -- FIXME: tweak this. maybe use outside of terminal too
  local blink = 'blinkwait777-blinkon1111-blinkoff666-Cursor'
  local normal_cursor = 'c-n-v-ve:block-' .. blink
  local insert_cursor = 'i-ci:ver25-' .. blink
  local replace_cursor = 'r-cr:hor20-' .. blink
  local operator_cursor = 'o:hor50-' .. blink
  local showmatch_cursor = 'sm:block-' .. blink

  -- Follow: https://github.com/neovim/neovim/pull/31562
  vim.o.guicursor = table.concat({
    normal_cursor,
    insert_cursor,
    replace_cursor,
    operator_cursor,
    showmatch_cursor,
  }, ',')

  local font = nixInfo(false, 'settings', 'guifont')
  if font ~= '' then
    vim.o.guifont = font
  end
end
