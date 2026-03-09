if vim.g.neovide then
  vim.opt.mouse = 'a'
  vim.api.nvim_create_autocmd('OptionSet', {
    pattern = 'mouse',
    callback = function()
      local info = debug.getinfo(2, 'S')
      print(
        'Mouse changed to: ' .. vim.v.option_new .. ' by ' .. (info and info.source or 'unknown')
      )
    end,
  })
  -- When using rounded borders in niri the lualine/tabs blocks clip at the edges
  vim.g.neovide_padding_top = 10
  vim.g.neovide_padding_bottom = 10
  vim.g.neovide_padding_right = 10
  vim.g.neovide_padding_left = 10

  local font = nixInfo(false, 'settings', 'guifont')
  if font ~= '' then
    vim.o.guifont = font
    print('Set font to' .. font)
  end

  local utils = require('utils')
  -- FIXME: Color name should probably come from external setting s
  if vim.g.colors_name == 'catppuccin-mocha' then
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

  vim.g.neovide_floating_shadow = true
  vim.g.neovide_floating_z_height = 10

  -- Follow: https://github.com/neovim/neovim/pull/31562
  vim.o.guicursor = table.concat({
    normal_cursor,
    insert_cursor,
    replace_cursor,
    operator_cursor,
    showmatch_cursor,
  }, ',')


  --[[ Neovide keymaps ]]
  -- stylua: ignore start
  vim.keymap.set({ 'i', "n", "x", "v" }, '<C-S-v>', '<C-r>+',
    { noremap = true, silent = true, desc = 'Paste from clipboard from within most modes' })
  -- IMPORTANT: without `silent = false` pasting into cmdline mode won't show up immediately in neovide
  vim.keymap.set({ 'c', }, '<C-S-v>', '<C-r>+',
    { noremap = true, silent = false, desc = 'Paste from clipboard from within all modes' })
  vim.api.nvim_set_keymap('t', '<C-S-v>', '<C-\\><C-n>"+Pi', {noremap = true, silent = true, desc = 'Paste from clipboard from terminal mode'})

  -- Tweak font sizes
  vim.keymap.set({ "t", "n", "v" }, "<C-+>", function()
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1
  end)
  vim.keymap.set({ "t", "n", "v" }, "<C-->", function()
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1
  end)
  vim.keymap.set({ "t", "n", "v" }, "<C-=>", function()
    vim.g.neovide_scale_factor = 1
  end)

  -- FIXME:These aren't working yet
  vim.keymap.set({ "t", "n", "v" }, "<C-ScrollWheelUp>", function()
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1
  end)
  vim.keymap.set({ "n", "v" }, "<C-ScrollWheelDown>", function()
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1
  end)

  -- FIXME: This doesn't work
  vim.keymap.set(
    'n',
    '<LeftMouse>',
    '<LeftMouse><cmd>lua vim.api.nvim_set_current_win(vim.fn.getmousepos().winid)<CR>',
    { silent = true })
  -- stylua: ignore end

  -- FIXME: This should match a setting that is tied to monitor in the neovim config
  -- vim.g.neovide_refresh_rate = 75
end
