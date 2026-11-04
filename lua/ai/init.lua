local MP = ...
return {
  { import = MP:relpath('codecompanion') },
  -- { import = MP:relpath('copilot') },
  { import = MP:relpath('minuet'), enabled = nixInfo(false, 'settings', 'devMode') },
}
