return function() -- free are 50 reqs/day
  return require('codecompanion.adapters').extend('openai_compatible', {
    env = {
      url = 'https://integrate.api.nvidia.com',
      api_key = 'NVIDIA_API_KEY',
      chat_url = '/v1/chat/completions',
    },
    schema = {
      model = {
        default = 'nvidia/nemotron-3-nano-30b-a3b',
        choices = {
          ['nvidia/nemotron-3-nano-30b-a3b'] = { opts = { can_reason = true } },
        },
      },
      max_tokens = {
        mapping = 'parameters',
        default = 16384,
      },
    },
  })
end
