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
