-- stylua: ignore start
-- [[ Basic Keymaps ]]

-- Reload config. Only applicable if devMode is set
vim.keymap.set("n", "<leader><leader>r", ":ReloadConfig<CR>", {noremap = true, silent = true})

vim.keymap.set("n", "qq", vim.cmd.quitall, {noremap = true, silent = true})

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = 'Moves Line Down' })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = 'Moves Line Up' })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = 'Scroll Down' })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = 'Scroll Up' })
-- FIXME: since flash remaps n for some stuff, not sure if this is still relevant
vim.keymap.set("n", "n", "nzzzv", { desc = 'Next Search Result' })
vim.keymap.set("n", "N", "Nzzzv", { desc = 'Previous Search Result' })

-- typo tolerant command abbreviations for :W and friends
-- neovide will use confirm-quit.nvim version
vim.keymap.set("ca", "W", "w")
if not vim.g.neovide then
  vim.keymap.set("ca", "Wq", "wq")
  vim.keymap.set("ca", "WQ", "wq")
  vim.keymap.set("ca", "Q", "q")
end

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })


-- vim.keymap.set({ "v", "x", "n" }, '<leader>y', '"+y', { noremap = true, silent = true, desc = 'Yank to clipboard' })
-- vim.keymap.set({ "n", "v", "x" }, '<leader>Y', '"+yy', { noremap = true, silent = true, desc = 'Yank line to clipboard' })
vim.keymap.set({ "n", "v", "x" }, '<C-a>', 'gg0vG$', { noremap = true, silent = true, desc = 'Select all' })
-- vim.keymap.set({ 'n', 'v', 'x' }, '<leader>p', '"+p', { noremap = true, silent = true, desc = 'Paste from clipboard' })

vim.keymap.set("n", "<leader>yfp", function() vim.fn.setreg("+", vim.fn.expand("%:p")) end,
  { desc = "Copy full file path" })
vim.keymap.set("n", "<leader>yrp", function() vim.fn.setreg("+", vim.fn.expand("%")) end,
  { desc = "Copy relative file path" })

vim.keymap.set('i', '<C-v>', '<C-r><C-p>+',
  { noremap = true, silent = true, desc = 'Paste from clipboard from within insert mode' })
vim.keymap.set("x", "<leader>P", '"_dP',
  { noremap = true, silent = true, desc = '[P]aste over selection without erasing unnamed register' })


-- LSP
local l = "<leader>l"
vim.keymap.set("n", l .. "x", vim.cmd.LspStop,  { desc = 'Turn of LSP' })
vim.keymap.set("n", l .. "o", vim.cmd.LspStart, { desc = 'Turn on LSP' })

-- Window/split motions
-- See smart-splits.nvim maps instead

local nv = { "n", "v" }
local nvi = { "n", "v", "i" }

-- Buffer motions
-- l = "<A-b>"
l = "<leader>b"
vim.keymap.set(nv, l .. "h", vim.cmd.bprev,   { desc = 'Previous buffer' })
vim.keymap.set(nv, l .. "l", vim.cmd.bnext,   { desc = 'Next buffer' })
vim.keymap.set(nv, l .. ".", "<cmd>b#<CR>",   { desc = 'Most recent buffer' })
vim.keymap.set(nv, l .. "s", vim.cmd.ls,      { desc = 'List buffers' })
vim.keymap.set(nv, l .. "x", vim.cmd.bdelete, { desc = 'Delete buffer' })

-- Tab motions
local function rename_tab()
    vim.ui.input({ prompt = 'New Tab Name: ' }, function (input)
    if input or input == '' then
      vim.cmd.LualineRenameTab(input)
      require('lualine').refresh({ scope = 'all', place = { 'tabline' } })
    end
  end)
end

local function create_named_tab()
  vim.cmd.tabnew()
  rename_tab()
end

l = "<A-t>"
vim.keymap.set(nvi, l .. "e", vim.cmd.tablast,  { silent = true, desc = 'Go to last tab' })
vim.keymap.set(nvi, l .. "0", vim.cmd.tabfirst, { silent = true, desc = 'Go to first tab' })
vim.keymap.set(nvi, l .. "h", "gT",             { silent = true, desc = 'Go to previous tab' })
vim.keymap.set(nvi, l .. "l", "gt",             { silent = true, desc = 'Go to next tab' })
vim.keymap.set(nvi, l .. ".", "g<tab>",         { silent = true, desc = 'Go to last accessed tab page' })
vim.keymap.set(nvi, l .. "x", vim.cmd.tabclose, { silent = true, desc = 'Close current tab' })
vim.keymap.set(nvi, l .. "H", "<cmd>:-tabmove<CR>",      { silent = true, desc = 'Move tab to left' })
vim.keymap.set(nvi, l .. "L", "<cmd>:+tabmove<CR>",      { silent = true, desc = 'Move tab to right' })
vim.keymap.set(nvi, l .. "n", vim.cmd.tabnew,   { silent = true, desc = 'Create unnamed tab' })
vim.keymap.set(nvi, l .. "N", create_named_tab, { silent = true, desc = 'Create named tab' })
vim.keymap.set(nvi, l .. 'r', rename_tab,       { silent = true, desc = 'Rename tab' })

local function smart_open(direction)
  local cmd = (direction == 'h' or direction == 'l') and 'vnew' or 'new'
  local modifier = ''

  if direction == 'h' then modifier = 'topleft '
  elseif direction == 'l' then modifier = 'botright '
  elseif direction == 'k' then modifier = 'topleft '
  elseif direction == 'j' then modifier = 'botright '
  end

  vim.cmd(modifier .. cmd)
end

vim.keymap.set('n', '<A-n>h', function() smart_open('h') end, { desc = "Split Left" })
vim.keymap.set('n', '<A-n>l', function() smart_open('l') end, { desc = "Split Right" })
vim.keymap.set('n', '<A-n>k', function() smart_open('k') end, { desc = "Split Up" })
vim.keymap.set('n', '<A-n>j', function() smart_open('j') end, { desc = "Split Down" })

local function scroll(cmd)
  local current_so = vim.opt.scrolloff:get()
  vim.opt.scrolloff = 0
  vim.cmd('normal! ' .. cmd)
  vim.opt.scrolloff = current_so
end

-- Put line to actual top/bottom (ignores scrolloff)
vim.keymap.set('n', 'zT', function()
  scroll('zt')
end, { desc = "Force zt ignoring scrolloff" })
vim.keymap.set('n', 'zB', function()
  scroll('zb')
end, { desc = "Force zt ignoring scrolloff" })

-- Remap marks since m is used elsewhere
vim.keymap.set('n', '<leader>m', 'm', {noremap=true, silent=true, desc = "Marks: Set [a-z] (Built-in)"})

local function dismiss_all()
  require("noice").cmd("dismiss")
  require("notify").dismiss({ silent = true })
  vim.cmd("noh")
end

vim.keymap.set("n", "<Esc>", dismiss_all, { desc = "Dismiss all notifications and clear hlsearch" })
-- blink uses <c-e> to close pop-up so same idea
vim.keymap.set({ "v", "n", "t", "c"}, "<A-e>", dismiss_all, { desc = "Dismiss all notifications and clear hlsearch" })

vim.keymap.set("n", "<leader>Ts", function() vim.opt.spell = not vim.opt.spell:get() end, { desc = "Toggle spell checking" })
-- FIXME: add toggle for numbers

--[[
 Experimental keymaps

 Stuff I'm trying, but don't know if I'll keep
]]
vim.keymap.set('i', 'jk', '<ESC>:w<CR>', {noremap=true, silent=true})

-- stylua: ignore end

