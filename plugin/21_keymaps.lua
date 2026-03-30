-- stylua: ignore start

local nv  = { "n", "v" }
local nvi = { "n", "v", "i" }

--
-- [[ Quality of Life ]]
--

-- Jump to the next search result, center it, and unfold (if relevant)
-- WARNING: These break better-n
-- vim.keymap.set("n", "n", "nzzzv", { desc = 'Next Search Result' })
-- vim.keymap.set("n", "N", "Nzzzv", { desc = 'Previous Search Result' })

-- WARNING: This breaks registers
-- vim.keymap.set("n", "qq", vim.cmd.quitall, {noremap = true, silent = true})

--
-- [[ Diagnostics ]]
--
-- Also see ./../lua/ui/trouble.lua

vim.keymap.set('n', '[d', function() vim.diagnostic.jump({count=-1, float=true}) end, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', function() vim.diagnostic.jump({count=1, float=true}) end,  { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float,                           { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist,                           { desc = 'Open diagnostics list' })

--
-- [[ Copy / Paste ]]
--
vim.keymap.set({ "n", "v" }, '<C-a>', 'gg0vG$', { noremap = true, silent = true, desc = 'Select all' })

vim.keymap.set("n", "<leader>yfp", function() vim.fn.setreg("+", vim.fn.expand("%:p")) end,
  { desc = "Copy full file path" })
vim.keymap.set("n", "<leader>yrp", function() vim.fn.setreg("+", vim.fn.expand("%")) end,
  { desc = "Copy relative file path" })
vim.keymap.set('i', '<C-v>', '<C-r><C-p>+',
  { noremap = true, silent = true, desc = 'Paste from clipboard from within insert mode' })
vim.keymap.set("x", "<leader>P", '"_dP',
  { noremap = true, silent = true, desc = '[P]aste over selection without erasing unnamed register' })

vim.keymap.set({ "n", "o", }, 'gP', "i<CR><Esc>PkJxJx", { desc = "Paste line without breaks before cursor"} )
vim.keymap.set({ "n", "o", }, 'gp', "a<CR><Esc>PkJxJx", { desc = "Paste line without breaks after cursor"} )

--
-- [[ LSP ]]
--
-- Also see ./../lua/lsp/init.lua
local l = "<leader>l"
vim.keymap.set("n", l .. "x", vim.cmd.LspStop,  { desc = 'Turn of LSP' })
vim.keymap.set("n", l .. "o", vim.cmd.LspStart, { desc = 'Turn on LSP' })

--
-- [[ Notifications ]]
--

local function dismiss_all()
  require("noice").cmd("dismiss")
  require("notify").dismiss({ silent = true })
  vim.cmd("noh")
end

vim.keymap.set("n", "<Esc>", dismiss_all, { desc = "Dismiss all notifications and clear hlsearch" })
-- blink uses <c-e> to close pop-up so same idea
vim.keymap.set({ "v", "n", "t", "c"}, "<A-e>", dismiss_all, { desc = "Dismiss all notifications and clear hlsearch" })

vim.keymap.set("n", "<leader>ts", function() vim.opt.spell = not vim.opt.spell:get() end, { desc = "Toggle spell checking" })
-- FIXME: add toggle for numbers


vim.keymap.set('n', "<leader><leader>t", vim.cmd.InspectTree, { desc = "Treesitter inspection" })

--
-- [[ Experimental ]]
-- 
-- Stuff I'm trying, but don't know if I'll keep
vim.keymap.set('i', 'jk', '<ESC>:w<CR>', {noremap=true, silent=true})

-- Fix most recent spelling mistake. Operations
-- 1. Set undo breakpoint
-- 2. Switch to normal mode and auto-select first spell suggestion
-- 3. Return to after last text changed
-- 4. Set undo breakpoint
-- From: https://github.com/theopn/dotfiles/blob/c96a769b/vim/.vimrc
vim.keymap.set({"i", "n", "o"}, "<C-s>", "<C-g>u<ESC>[s1z=`]a<C-g>u", { desc = "Auto-spell correct"})

-- sudo save
vim.keymap.set(
    'c',
    'w!!',
    '<cmd>w !sudo tee > /dev/null %<cr>',
    { desc = '`sudo save` privileged files' }
  )

-- stylua: ignore end
