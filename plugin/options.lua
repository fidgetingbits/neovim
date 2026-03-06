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
end
