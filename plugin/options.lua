-- See `:help vim.o`

-- Hide the message output line below the status bar
-- FIXME: We probably only want this in terminal mode
-- vim.o.cmdheight = 0

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.o.list = true
--vim.o.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Set highlight on search
vim.o.hlsearch = true

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10
-- Unlimited scrollback in terminal
vim.o.scrollback = -1

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Splits
vim.o.equalalways = false

-- Indent
-- vim.o.smarttab = true
vim.opt.cpoptions:append('I')
vim.o.expandtab = true
-- vim.o.smartindent = true
-- vim.o.autoindent = true
-- vim.o.tabstop = 4
-- vim.o.softtabstop = 4
-- vim.o.shiftwidth = 4

-- stops line wrapping from being confusing
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'
vim.wo.relativenumber = true

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menu,preview,noselect'

-- Show the current cursor line
vim.o.cursorline = true

-- Spelling
-- FIXME: Would be nice to sync this across systems somehow
-- Maybe use https://github.com/minhanghuang/spell.nvim too
local spell_path = vim.fn.stdpath('data') .. '/spell/en.utf-8.add'
vim.fn.mkdir(vim.fn.fnamemodify(spell_path, ':h'), 'p')
vim.o.spellpath = spell_path
vim.o.spell = true

vim.o.termguicolors = true

vim.g.netrw_liststyle = 0
vim.g.netrw_banner = 0

-- Default: "ltToOCF"
-- Disable:
-- s - search hit TOP
-- W - written messages
-- I - intro messages
vim.opt.shortmess:append('sIW')

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

  -- FIXME: tweak this
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
end
