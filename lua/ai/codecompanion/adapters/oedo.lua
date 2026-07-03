return function()
  return require('codecompanion.adapters').extend('openai_compatible', {
    schema = {
      model = {
        default = 'Qwen 3.6 Coder 30B (Light)',
        name = 'qwen3-coder',
      },
    },
    env = {
      url = 'http://' .. vim.env.OEDO .. ':' .. vim.env.LLAMA_SWAP_PORT,
      api_key = 'LLAMA_SWAP_API_KEY',
      chat_url = '/v1/chat/completions',
    },
  })
end
