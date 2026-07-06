return function()
  return require('codecompanion.adapters').extend('openai_compatible', {
    schema = {
      model = {

        default = 'Qwen 2.5 Coder 1.5B (Ultra Light)',
        name = 'qwen2.6:coder-1.5b',
      },
    },
    env = {
      url = 'http://' .. vim.env.OSSA .. ':' .. vim.env.LLAMA_SWAP_PORT,
      api_key = 'LLAMA_SWAP_API_KEY',
      chat_url = '/v1/chat/completions',
    },
  })
end
