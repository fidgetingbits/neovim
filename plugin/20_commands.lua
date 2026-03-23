-- Reloads /plugin files for now only
vim.api.nvim_create_user_command('ReloadConfig', function()
  -- Source init.lua
  config_folder = nixInfo(false, 'settings', 'config_directory')
  -- FIXME:LZE complains on reload, with 'attempted to add <foo> twice' error spam
  -- need to figure out if there is a way to do that
  -- dofile(config_folder .. '/init.lua')

  -- Reload some critical runtime files
  local function source_files(path)
    local files = vim.fn.glob(path, false, true)
    for _, file in ipairs(files) do
      local ok, err = pcall(vim.cmd, 'silent! source ' .. file)
      if not ok then
        print('Error sourcing ' .. file .. ': ' .. err)
      end
      -- print('Loaded ' .. file)
    end
  end
  source_files(config_folder .. '/plugin/**/*.vim')
  source_files(config_folder .. '/plugin/**/*.lua')
  source_files(config_folder .. '/ftplugin/**/*.vim')
  source_files(config_folder .. '/ftplugin/**/*.lua')

  -- Force re-detection of filetype for the current buffer
  vim.cmd('filetype detect')

  vim.cmd('ReloadSnippets')

  print('Configuration reloaded!')
end, {})
