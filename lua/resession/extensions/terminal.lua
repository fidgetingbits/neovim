local M = {}

---@param winid integer
---@param bufnr integer
---@return boolean
M.is_win_supported = function(_, bufnr)
  return vim.bo[bufnr].buftype == 'terminal'
end

---@param winid integer
---@return any
M.save_win = function(winid)
  local bufnr = vim.api.nvim_win_get_buf(winid)
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  return {
    bufname = bufname,
    term_name = vim.b[bufnr].term_name,
  }
end

---@param winid integer
---@param config any
---@return integer|nil If the original window has been replaced, return the new ID that should replace it
M.load_win = function(winid, data)
  local bufnr = vim.fn.bufadd(data.bufname)
  vim.api.nvim_win_set_buf(winid, bufnr)
  vim.b[bufnr].term_name = data.term_name

  return nil
end

return M
