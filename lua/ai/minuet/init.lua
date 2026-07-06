-- See https://github.com/ViViDboarder/vim-settings/blob/40db7914e5268e0462f5a4f48008e9ecb915df81/neovim/lua/config/plugins/llm_assist.lua#L163
-- for some  ideas of abstracting the models a bit
return {
  {
    'minuet-ai.nvim',
    on_plugin = { 'blink.cmp' }, -- Wait for blink
    dep_of = { 'lualine.nvim' },

    after = function(plugin)
      local fim_optional = {
        max_tokens = 56, -- FIXME: Why 56? Should we bump this?
        top_p = 0.9,
        provider = {
          sort = 'throughput',
        },
        -- disable thinking to avoid first token latency
        reasoning_effort = 'none',
      }

      local providers = require('ai.minuet.providers')
      local provider = vim.deepcopy(providers.configs[providers.default])
      provider.model = provider.models[provider.model]
      provider.optional = fim_optional

      local default_provider = {
        provider = 'openai_fim_compatible',
        provider_options = {
          openai_fim_compatible = {
            name = 'ossa',
            api_key = 'LLAMA_SWAP_API_KEY',
            end_point = 'http://ossa:11435/v1/completions',
            model = 'Qwen 2.5 Coder 1.5B (Ultra Light)',
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
        },
      }

      -- Setup initial minuet use the default llm provider. Use <FUNCTION NAME> to swap it
      -- at runtime
      -- FIXME: See about increasing surrounding context for FIM. How much gets passed?
      -- Should it include the whole function, etc?
      require('minuet').setup({

        -- NOTE: These get replaced by the presets
        n_completions = 1, -- recommend for local model for resource saving
        throttle = 1000, -- only send the request every x milliseconds, use 0 to disable throttle.
        debounce = 250, -- debounce the request in x milliseconds, set to 0 to disable debounce
        context_window = 512,
        request_timeout = 3,

        -- Default - Swap with minuet provider <name>
        provider = default_provider.provider,
        provider_options = vim.tbl_extend('force', default_provider.provider_options, {
          -- Recommended non-default gemini settings from README
          gemini = {
            optional = {
              generationConfig = {
                maxOutputTokens = 256,
                thinkingConfig = {
                  -- Disable thinking for gemini 2.5 models
                  thinkingBudget = 0,
                },
              },
              safetySettings = {
                {
                  category = 'HARM_CATEGORY_DANGEROUS_CONTENT',
                  threshold = 'BLOCK_NONE',
                },
              },
            },
          },
        }),

        -- Presets (extra configs)
        -- https://github.com/milanglacier/minuet-ai.nvim#minuet-change_preset
        presets = {
          -- Abstract this since it's duplicated with the default
          ossa = {
            provider = 'openai_fim_compatible',
            provider_options = {
              name = 'ossa',
              api_key = 'LLAMA_SWAP_API_KEY',
              end_point = 'http://ossa:11435/v1/completions',
              model = 'Qwen 2.5 Coder 1.5B (Ultra Light)',
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
          },
          oedo = {
            -- Configuration for cloud-based requests with large context window
            provider = 'openai_fim_compatible',
            provider_options = {
              openai_fim_compatible = {
                name = 'oedo',
                api_key = 'LLAMA_SWAP_API_KEY',
                model = 'Qwen 3.6 General 35B Q8 (Light)',
                end_point = 'http://oedo:11435/v1/completions',
              },
            },
          },

          openrouter = {
            provider = 'openai_compatible',
            provider_options = {
              model = 'google/gemma-4-31b-it:free',
              name = 'openrouter',
              end_point = 'https://openrouter.ai/api/v1/chat/completions',
              api_key = 'OPENROUTER_API_KEY',
            },
          },

          nvidia = {
            provider = 'openai_compatible',
            provider_options = {
              model = 'qwen/qwen3-coder-480b-a35b-instruct',
              end_point = 'https://integrate.api.nvidia.com/v1/chat/completions',
              api_key = 'NVIDIA_API_KEY', -- build.nvidia.com, free tier: 1000 credits, 40 req/min
            },
          },
        },

        -- FIXME: Revisit the keybinding
        -- Virtual text (ghost text) configuration
        virtualtext = {
          auto_trigger_ft = { '*' },
          -- Disable in certain file types
          auto_trigger_ignore_ft = { 'TelescopePrompt', 'neo-tree', 'NvimTree' },
          keymap = {
            -- Accept whole completion
            accept = '<A-a>',
            -- Accept one line
            accept_line = '<A-l>',
            -- Cycle to next completion
            next = '<A-]>',
            -- Cycle to prev completion
            prev = '<A-[>',
            -- Dismiss completion
            -- Verify this falls back? Because we use it lots of places
            dismiss = nil,
          },
          -- Show virtual text even when completion menu is visible
          show_on_completion_menu = false,
        },

        blink = {
          -- enable_auto_complete = false, -- Only enable FIM when toggled
          enable_auto_complete = true,
        },
      })

      local l = '<leader>am'
      vim.keymap.set({ 'n' }, l .. 'b', function()
        local m = require('minuet')
        local v = m.config.blink.enable_auto_complete
        m.config.blink.enable_auto_complete = not v
        vim.notify('Minuet: blink completion toggled ' .. (v and 'off' or 'on'))
      end, { desc = 'Minuet: enable/disable blink completion' })

      vim.keymap.set({ 'n' }, l .. 'v', function()
        vim.cmd('Minuet virtualtext toggle')
      end, { desc = 'Minuet: enable/disable virtual text in buffer' })

      local keymap = require('blink.cmp.config').keymap
      -- FIXME: Switch this ?
      keymap['<A-y>'] = require('minuet').make_blink_map()
      -- Manually invoke minuet completion.
      require('blink.cmp').add_source_provider('minuet', {
        name = 'minuet',
        module = 'minuet.blink',
        async = true,
        -- Should match minuet.config.request_timeout * 1000,
        -- since minuet.config.request_timeout is in seconds
        timeout_ms = 3000,
        score_offset = 45, -- FIXME: See introdus. This is lower prio than lsp/snippet, but higher than others
      })
    end,
  },
}
