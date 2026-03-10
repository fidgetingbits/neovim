-- [[ Disable auto comment on enter ]]
-- See :help formatoptions
vim.api.nvim_create_autocmd('FileType', {
  desc = 'remove formatoptions',
  callback = function()
    vim.opt.formatoptions:remove({ 'c', 'r', 'o' })
  end,
})

-- [[ Highlight on yank ]]
-- See `:help vim.hl.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.hl.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- FIXME: revisit, ported from old config
-- Keep a list of the most recent two tabs.
-- Originally taken from:
-- https://vi.stackexchange.com/questions/9231/focus-previous-tab-window-when-closing-current
local tablisttrack_group = vim.api.nvim_create_augroup('TabListTrack', { clear = true })
vim.g.tablist = { 1, 1 }
-- When a tab is closed, return to the most recent tab.
-- The way vim updates tabs, in reality, this means we must return
--  to the second most recent tab.

vim.api.nvim_create_autocmd('TabNewEntered', {
  callback = function()
    vim.g.tablist[1] = vim.g.tablist[2]
    vim.g.tablist[2] = vim.fn.tabpagenr()
  end,
  group = tablisttrack_group,
  pattern = '*',
})
vim.api.nvim_create_autocmd('TabClosed', {
  callback = function()
    vim.cmd('tabnext ' .. vim.g.tablist[1])
  end,
  group = tablisttrack_group,
  pattern = '*',
})

-- FIXME: Revisit, see if we still need this, from old config
-- [[ File type specific formatting rules]]
local formatting_group = vim.api.nvim_create_augroup('Formatting', { clear = true })
-- Avoid spooky indents when doing `gqap` and such
-- http://stackoverflow.com/questions/1736771/using-vims-gqap-sometimes-indents-unusually#1745850
vim.api.nvim_create_autocmd('BufEnter', {
  callback = function()
    vim.bo.cindent = false
  end,
  group = formatting_group,
  pattern = '*.md,*.txt,.gitignore',
})

--[[
-- If there's no file type assume it is just a text file, and don't do any
-- fancy C indenting. useful for quick note taking
vim.api.nvim_create_autocmd('BufNewFile,BufRead,BufEnter', {
  callback = function()
    if vim.bo.filetype == '' then
      vim.bo.cindent = false
    end
  end,
  group = formatting_group,
  pattern = '*',
})
]]

-- From https://loosh.ch/blog/neovidenal, which is to
-- stop git hanging once we close the buffer
-- FIXME: revisit if this is necessary
vim.api.nvim_create_autocmd('FileType', {
  -- Git waits for all the buffers it has created to
  -- be closed.
  pattern = { 'git*' },
  callback = function()
    vim.bo.bufhidden = 'delete'
  end,
})
