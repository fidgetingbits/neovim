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

-- [[ Return to most recent tab on tab closure ]]
local tablisttrack = vim.api.nvim_create_augroup('TabListTrack', { clear = true })
vim.g.last_tabs = { vim.api.nvim_get_current_tabpage(), vim.api.nvim_get_current_tabpage() }

vim.api.nvim_create_autocmd('TabEnter', {
  callback = function()
    local tabs = vim.g.last_tabs
    tabs[1] = tabs[2]
    tabs[2] = vim.api.nvim_get_current_tabpage()
    vim.g.last_tabs = tabs
  end,
  group = tablisttrack,
})

vim.api.nvim_create_autocmd('TabClosed', {
  callback = function()
    local last_tab = vim.g.last_tabs[1]
    if vim.api.nvim_tabpage_is_valid(last_tab) then
      vim.api.nvim_set_current_tabpage(last_tab)
    end
  end,
  group = tablisttrack,
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
