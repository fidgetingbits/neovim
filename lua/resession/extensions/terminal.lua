local M = {}

---Save custom metadata for terminal buffers
---@param opts resession.Extension.OnSaveOpts Information about the session being saved
---@return any
M.on_save = function(opts)
  return {}
  -- FIXME: Not sure how to solve this in light of not being able to get 
  -- layout data in the extension for on_post_load to do it's thing
  local data = { buffers = {} }
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[bufnr].buftype == 'terminal' then
      -- bufname is unique identifier because of pid
      local bufname = vim.api.nvim_buf_get_name(bufnr)
      data.buffers[bufname] = {
        term_name = vim.b[bufnr].term_name,
      }
    end
  end
  return data
end

---Restore the extension state
---@param data The value returned from on_save
M.on_pre_load = function(data)
  -- This is run before the buffers, windows, and tabs are restored
end

---Restore custom metadata for terminal buffers
---@param data The value returned from on_save
M.on_post_load = function(data)
  return
  -- FIXME: Can't access session name, so don't know how to access the layout data
  -- The bufname will change when vim opens term:// because it includes pid
  -- but we have the old bufname in the session data, so we can walk the win
  -- layout and match the current window against the old bufname, and then
  -- update as needed
  local util = require('resession.utils')
  local files = require('resession.files')
  local layout = require('resession.layout')
  local filename = util.get_session_file(session_name, opts.dir)
  local data = files.load_json_file(filename)
end

---Called when resession gets configured
---This function is optional
---@param data table The configuration data passed in the config
M.config = function(data)
  --
end

---Check if a window is supported by this extension
---This function is optional, but if provided save_win and load_win must
---also be present.
---@param winid integer
---@param bufnr integer
---@return boolean
M.is_win_supported = function(winid, bufnr)
  return false
end

---Save data for a window
---@param winid integer
---@return any
M.save_win = function(winid)
  -- This is used to save the data for a specific window that contains a non-file buffer (e.g. a filetree).
  return {}
end

---Called with the data from save_win
---@param winid integer
---@param config any
---@return integer|nil If the original window has been replaced, return the new ID that should replace it
M.load_win = function(winid, config)
  -- Restore the window from the config
end

return M
