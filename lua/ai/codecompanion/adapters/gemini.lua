return function()
  local adapter = require('codecompanion.adapters').extend('gemini', {})

  -- Overrides the default and model choices completely.
  adapter.schema.model.default = 'gemini-3.5-flash'
  adapter.schema.model.choices = {
    ['gemini-3.5-flash'] = {
      formatted_name = 'Gemini 3.5 Flash (Default)',
      meta = { context_window = 1048576 },
      opts = { can_reason = true, has_vision = true },
    },
    ['gemini-3.1-flash-lite'] = {
      formatted_name = 'Gemini 3.1 Flash Lite',
      meta = { context_window = 1048576 },
      opts = { can_reason = false, has_vision = true },
    },
  }

  return adapter
end
