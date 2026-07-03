return {
  {
    'minuet-ai.nvim',
    on_plugin = { 'blink.cmp' }, -- Wait for blink

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
      -- resolve selected model key -> actual model id
      -- example: "coder" alias becomes something real like "fim:qwen-1.5b"
      provider.model = provider.models[provider.model]
      provider.optional = fim_optional

      -- Setup initial minuet use the default llm provider. Use <FUNCTION NAME> to swap it
      -- at runtime
      -- FIXME: See about increasing surrounding context for FIM. How much gets passed?
      -- Should it include the whole function, etc?
      require('minuet').setup({
        provider = provider.type,
        provider_options = {
          -- The provider table doubles as provider_options and a description of the
          -- provider itself, thus the use of type
          [provider.type] = provider,
          blink = {
            -- enable_auto_complete = false, -- Only enable FIM when toggled
            enable_auto_complete = true,
          },

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
        },
      })

      local l = '<leader>a'
      vim.keymap.set({ 'n' }, l .. 'm', function()
        local m = require('minuet')
        local v = m.config.blink.enable_auto_complete
        m.config.blink.enable_auto_complete = not v
        vim.notify('Minuet: blink completion toggled ' .. (v and 'off' or 'on'))
      end, { desc = 'Minuet: enable/disable blink completion' })

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

      -- FIXME: Make this a telescope selector for swapping the provider out
      vim.api.nvim_create_user_command('MinuetProvider', function(opts)
        local p = require('ai.minuet.providers').configs[opts.args]
        if p then
          local provider = vim.tbl_extend('force', require('minuet').config[p.type], p)
          provider.optional = fim_optional
          -- Copy in the table as provider_options
          require('minuet').config[p.type] = provider
          print('Switched to provider: ' .. opts.args)
        end
      end, {
        nargs = 1,
        complete = function()
          local providers = {}
          for key, _ in pairs(require('ai.minuet.providers').configs) do
            providers[#providers + 1] = key
          end
          return providers
        end,
      })
      -- FIXME: Need a function for setting the model for a given provider as well
    end,
  },
}
