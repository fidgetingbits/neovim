-- List of providers used for Fill-in-the-Middle
--
-- Minuet doesn't support hot swapping openai_compatible/openai_fim_compatible
-- entries, so we use this table to allow that
--
-- 'configs' entries largely mirror minuet provider_options, but with some
-- extras for to aid hot swapping providers
return {
  default = 'ossa',
  configs = {
    ossa = {
      name = 'ossa',
      type = 'openai_fim_compatible',
      default = 'coder',
      models = {
        coder = 'Qwen 2.5 Coder 1.5B (Ultra Light)',
      },

      -- minuet provider_options
      api_key = 'LLAMA_SWAP_API_KEY',
      end_point = 'http://ossa:11435/v1/completions',
      model = 'coder', -- Overwritten at setup from associated models below
      template = { -- See minuet README for details
        prompt = function(context_before_cursor, context_after_cursor, _)
          return '<|fim_prefix|>'
            .. context_before_cursor
            .. '<|fim_suffix|>'
            .. context_after_cursor
            .. '<|fim_middle|>'
        end,
        suffix = false,
      },
    },

    oedo = {
      name = 'oedo',
      type = 'openai_fim_compatible',
      default = 'coder',
      models = {
        coder = 'Qwen 3.6 General 35B Q4 (Light)',
      },

      -- minuet provider_options
      end_point = 'http://oedo:11435/v1/completions',
      api_key = 'LLAMA_SWAP_API_KEY',
      model = 'coder', -- Overwritten at setup from associated models below
      template = { -- See minuet README for details
        prompt = function(context_before_cursor, context_after_cursor, _)
          return '<|fim_prefix|>'
            .. context_before_cursor
            .. '<|fim_suffix|>'
            .. context_after_cursor
            .. '<|fim_middle|>'
        end,
        suffix = false,
      },
    },

    -- FIXME: Revisit the models for the below, as I just lifted them from examples

    openrouter = {
      name = 'openrouter',
      type = 'openai_compatible',
      models = {
        coder = 'qwen/qwen3-coder:free', -- best free coding model, 256k-1M ctx
        reasoning = 'deepseek/deepseek-v4-flash:free', -- strong reasoning, 1M ctx
        agentic = 'nvidia/nemotron-3-ultra:free', -- 1M ctx agentic tasks
      },

      -- minuet provider_options
      end_point = 'https://openrouter.ai/api/v1/chat/completions',
      api_key = 'OPENROUTER_API_KEY', -- openrouter.ai/keys -- only ":free"-suffixed models are free
      default = 'coder', -- Overwritten at setup from associated models below
    },

    nvidia = {
      name = 'Nvidia NIM',
      type = 'openai_compatible',
      models = {
        coder = 'qwen/qwen3-coder-480b-a35b-instruct', -- purpose-built coding, 256k ctx
        general = 'meta/llama-4-maverick-instruct', -- general purpose, most-used on platform
        agentic = 'mistralai/mistral-nemotron-instruct', -- tuned for function calling/agentic flows
      },

      -- minuet provider_options
      end_point = 'https://integrate.api.nvidia.com/v1/chat/completions',
      api_key = 'NVIDIA_API_KEY', -- build.nvidia.com, free tier: 1000 credits, 40 req/min
      default = 'coder', -- Overwritten at setup from associated models below
    },

    zai = {
      name = 'Z.ai',
      type = 'openai_compatible',
      models = {
        coder = 'glm-4.5-air',
      },

      -- minuet provider_options
      end_point = 'https://api.z.ai/api/coding/paas/v4/chat/completions',
      api_key = 'ZAI_API_KEY',
      default = 'coder', -- Overwritten at setup from associated models below
    },
  },
}
