local M = {}

-- Some utils found here: https://github.com/theherk/commons/blob/main/.config/nvim/lua/module/util.lua
-- via this neovide discussion: https://github.com/neovide/neovide/discussions/2891
function M.set_cursor_colors(colors)
  vim.api.nvim_set_hl(0, 'Cursor', { bg = colors.blue, fg = 'black' })
  vim.api.nvim_set_hl(0, 'TermCursor', { bg = colors.blue, fg = 'black' })
end

-- This is bespoke to catppuccin at the moment, but should be expanded.
function M.set_term_colors(colors)
  vim.g.terminal_color_0 = colors.surface1
  vim.g.terminal_color_1 = colors.red
  vim.g.terminal_color_2 = colors.green
  vim.g.terminal_color_3 = colors.yellow
  vim.g.terminal_color_4 = colors.blue
  vim.g.terminal_color_5 = colors.pink
  vim.g.terminal_color_6 = colors.teal
  vim.g.terminal_color_7 = colors.subtext1
  vim.g.terminal_color_8 = colors.surface2
  vim.g.terminal_color_9 = colors.red
  vim.g.terminal_color_10 = colors.green
  vim.g.terminal_color_11 = colors.yellow
  vim.g.terminal_color_12 = colors.blue
  vim.g.terminal_color_13 = colors.pink
  vim.g.terminal_color_14 = colors.teal
  vim.g.terminal_color_15 = colors.subtext0
end

return M
