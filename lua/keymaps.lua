-- [[ Basic Keymaps ]]

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = 'Moves Line Down' })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = 'Moves Line Up' })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = 'Scroll Down' })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = 'Scroll Up' })
vim.keymap.set("n", "n", "nzzzv", { desc = 'Next Search Result' })
vim.keymap.set("n", "N", "Nzzzv", { desc = 'Previous Search Result' })


-- see help sticky keys on windows
vim.cmd([[command! W w]])
vim.cmd([[command! Wq wq]])
vim.cmd([[command! WQ wq]])
vim.cmd([[command! Q q]])

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

vim.keymap.set('i', '<C-p>', '<C-r><C-p>+',
  { noremap = true, silent = true, desc = 'Paste from clipboard from within insert mode' })
vim.keymap.set("x", "<leader>P", '"_dP',
  { noremap = true, silent = true, desc = 'Paste over selection without erasing unnamed register' })


-- LSP
local l = "<leader>l"
vim.keymap.set("n", l .. "x", ":LspStop<CR>", { desc = 'Turn of LSP' })
vim.keymap.set("n", l .. "o", ":LspStart<CR>", { desc = 'Turn on LSP' })

-- Window/split motions
-- See smart-splits.nvim maps instead

-- Buffer motions
local l = "<leader>b"
vim.keymap.set("n", l .. "h", "<cmd>bprev<CR>", { desc = 'Previous buffer' })
vim.keymap.set("n", l .. "l", "<cmd>bnext<CR>", { desc = 'Next buffer' })
vim.keymap.set("n", l .. ".", "<cmd>b#<CR>", { desc = 'Most recent buffer' })
vim.keymap.set("n", l .. "s", "<cmd>ls<CR>", { desc = 'List buffers' })
vim.keymap.set("n", l .. "x", "<cmd>bdelete<CR>", { desc = 'Delete buffer' })

-- Tab motions (FIXME: revisit)
l = "<leader><tab>"

vim.keymap.set("n", l .. "e", ":tablast", { noremap = true, silent = true, desc = 'Go to last tab' })
vim.keymap.set("n", l .. "0", ":tabfirst", { noremap = true, silent = true, desc = 'Go to first tab' })
vim.keymap.set("n", l .. "h", "gT", { noremap = true, silent = true, desc = 'Go to previous tab' })
vim.keymap.set("n", l .. "l", "gt", { noremap = true, silent = true, desc = 'Go to next tab' })
vim.keymap.set("n", l .. ".", "g<tab>", { noremap = true, silent = true, desc = 'Go to last accessed tab page' })
vim.keymap.set("n", l .. "<tab>", ":tabnew<CR>", { noremap = true, silent = true, desc = 'Open new tab' })
vim.keymap.set("n", l .. "x", ":tabclose", { noremap = true, silent = true, desc = 'Close current tab' })
vim.keymap.set("n", l .. "H", ":-tabmove", { noremap = true, silent = true, desc = 'Move tab to left' })
vim.keymap.set("n", l .. "L", ":+tabmove", { noremap = true, silent = true, desc = 'Move tab to right' })
