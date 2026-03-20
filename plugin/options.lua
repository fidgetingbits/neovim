-- See `:help vim.o`

-- default "blank,buffers,curdir,folds,help,tabpages,winsize,terminal"
vim.opt.sessionoptions:append({ 'globals', 'localoptions' })

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.o.list = true
vim.o.listchars = 'tab:»·,trail:·'

-- Set highlight on search
vim.o.hlsearch = true

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

-- Minimal number of screen lines to keep above and below the cursor.
-- See zT/zB for bypass
vim.o.scrolloff = 5

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
-- vim.o.timeoutlen = 300
-- Longer timeouts for when I brain fog
vim.o.timeoutlen = 3000
vim.o.ttimeoutlen = 100

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menu,preview,noselect'

-- Show the current cursor line
vim.o.cursorline = true

-- Spelling
-- FIXME: Would be nice to sync this across systems somehow
-- Maybe use https://github.com/minhanghuang/spell.nvim too
local spell_path = vim.fn.stdpath('data') .. '/spell/en.utf-8.add'
vim.fn.mkdir(vim.fn.fnamemodify(spell_path, ':h'), 'p')
vim.o.spellfile = spell_path
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

-- Stop modifying none vim files every time there opened and we :wq. This is
-- mostly to stop git detecting modifications
vim.o.endofline = false

-- Single status line at bottom of window for all windows
vim.opt.laststatus = 3

-- FIXME: Should make this a global so it's easier to fetch color palette?
vim.cmd.colorscheme('miasma')
