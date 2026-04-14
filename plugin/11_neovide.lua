-- See introdus for more introdus settings
if vim.g.neovide then
  vim.opt.mouse = 'a'
  -- FIXME: renable for debugging
  -- vim.api.nvim_create_autocmd('OptionSet', {
  --   pattern = 'mouse',
  --   callback = function()
  --     local info = debug.getinfo(2, 'S')
  --     print(
  --       'Mouse changed to: ' .. vim.v.option_new .. ' by ' .. (info and info.source or 'unknown')
  --     )
  --   end,
  -- })

  vim.g.neovide_confirm_quit = true

  -- When using rounded borders in niri the lualine/tabs blocks clip at the edges
  vim.g.neovide_padding_top = 10
  vim.g.neovide_padding_bottom = 10
  vim.g.neovide_padding_right = 10
  vim.g.neovide_padding_left = 10

  local font = nixInfo(false, 'settings', 'guifont')
  if font ~= '' then
    vim.o.guifont = font
    -- print('Set font to ' .. font)
  end

  local utils = require('utils')

  -- FIXME: Likely move this
  vim.cmd.colorscheme(vim.g.colorscheme)

  if vim.g.colors_name == 'miasma' then
    -- No built-in palette
    -- local colors =
  elseif vim.g.colors_name == 'catppuccin-mocha' then
    local colors = require('catppuccin.palettes').get_palette('mocha')
    vim.api.nvim_set_hl(0, 'Normal', { bg = colors.base })
    utils.set_cursor_colors(colors)
    utils.set_term_colors(colors)
  end

  vim.g.neovide_cursor_smooth_blink = true

  vim.g.neovide_hide_mouse_when_typing = true

  -- FIXME: tweak this. maybe use outside of terminal too
  local blink = 'blinkwait777-blinkon1111-blinkoff666-Cursor'
  local normal_cursor = 'c-n-v-ve:block-' .. blink
  local insert_cursor = 'i-ci:ver25-' .. blink
  local replace_cursor = 'r-cr:hor20-' .. blink
  local operator_cursor = 'o:hor50-' .. blink
  local showmatch_cursor = 'sm:block-' .. blink

  -- WARNING: Setting this to true messages up stuff like snacks dashboard
  vim.g.neovide_floating_shadow = false
  -- vim.g.neovide_floating_z_height = 10

  -- Follow: https://github.com/neovim/neovim/pull/31562
  vim.o.guicursor = table.concat({
    normal_cursor,
    insert_cursor,
    replace_cursor,
    operator_cursor,
    showmatch_cursor,
  }, ',')

  --[[ Neovide keymaps ]]

  -- FIXME:These aren't working yet
  vim.keymap.set({ 't', 'n', 'v' }, '<C-ScrollWheelUp>', function()
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1
  end)
  vim.keymap.set({ 'n', 'v' }, '<C-ScrollWheelDown>', function()
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1
  end)

  -- FIXME: This doesn't work
  vim.keymap.set(
    'n',
    '<LeftMouse>',
    '<LeftMouse><cmd>lua vim.api.nvim_set_current_win(vim.fn.getmousepos().winid)<CR>',
    { silent = true }
  )
  -- stylua: ignore end

  -- FIXME: This should match a setting that is tied to monitor in the neovim config
  -- vim.g.neovide_refresh_rate = 75
end
