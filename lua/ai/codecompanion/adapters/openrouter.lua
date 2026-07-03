return function() -- free are 50 reqs/day
  return require('codecompanion.adapters').extend('openai_compatible', {
    env = {
      url = 'https://openrouter.ai/api',
      api_key = 'OPENROUTER_API_KEY',
      chat_url = '/v1/chat/completions',
    },
    schema = {
      model = {
        default = 'nvidia/nemotron-3-super-120b-a12b:free',
        choices = {
          --
          'z-ai/glm-5.2',

          -- Free
          'google/gemma-4-31b-it:free',
          'nvidia/nemotron-3-super-120b-a12b:free',
        },
      },
    },
  })
end
