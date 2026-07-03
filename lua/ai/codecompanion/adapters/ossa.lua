return function()
  return require('codecompanion.adapters').extend('openai_compatible', {
    schema = {
      model = {
        default = 'fim:qwen-1.5',
        name = 'qwen-1.5',
      },
    },
    env = {
      url = 'http://' .. vim.env.OSSA .. ':' .. vim.env.LLAMA_SWAP_PORT,
      api_key = 'LLAMA_SWAP_API_KEY',
      chat_url = '/v1/chat/completions',
    },
  })
end
