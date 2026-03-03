return {
  {
    "blink.cmp.conventional.commits",
    dep_of = { "blink.cmp" },
  },
  {
    "colorful-menu.nvim",
    on_plugin = { "blink.cmp" },
  },
  -- FIXME: Revisit if cmp_cmdline is worth using
  {
    "blink.cmp",
    event = "DeferredUIEnter",
    after = function(_)
      require("blink.cmp").setup({
        -- See :h blink-cmp-config-keymap for configuring keymaps
        -- Also see ./luasnip.lua for additional keys, like node choices
        keymap = {
          -- FIXME: unset once done with the below
          preset = 'default',

          -- These are the defaults per: https://cmp.saghen.dev/configuration/keymap.html

          ['<C-space>'] = false,
          ['<Up>'] = false,
          ['<Down>'] = false,
          ['<Tab>'] = false,
          ['<S-Tab>'] = false,

          ['<C-s>'] = { 'show', 'show_documentation', 'hide_documentation', 'fallback' },
          ['<C-t>'] = { 'show_signature', 'hide_signature', 'fallback' },

          -- NOTE: c-e has some odd behavior, so is annoying if you over press
          -- ['<C-e>'] = { 'hide', 'hide_documentation', 'hide_signature', }, --'fallback' },
          ['<C-y>'] = { 'select_and_accept', 'fallback' },

          ['<C-p>'] = { 'select_prev', 'fallback_to_mappings' },
          ['<C-n>'] = { 'select_next', 'fallback_to_mappings' },

          ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
          ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },

          ['<C-j>'] = { 'snippet_forward', 'fallback' },
          ['<C-k>'] = { 'snippet_backward', 'fallback' },

        },
        cmdline = {
          enabled = true,
          completion = {
            menu = {
              auto_show = true,
            },
          },
          sources = function()
            local type = vim.fn.getcmdtype()
            -- Search forward and backward
            if type == '/' or type == '?' then return { 'buffer' } end
            -- Commands
            if type == ':' or type == '@' then return { 'cmdline', } end
            return {}
          end,
        },
        fuzzy = {
          sorts = {
            'exact',
            -- defaults
            'score',
            'sort_text',
          },
        },
        signature = {
          enabled = true,
          window = {
            show_documentation = true,
          },
        },
        completion = {
          menu = {
            draw = {
              treesitter = { 'lsp' },
              components = {
                label = {
                  text = function(ctx)
                    return require("colorful-menu").blink_components_text(ctx)
                  end,
                  highlight = function(ctx)
                    return require("colorful-menu").blink_components_highlight(ctx)
                  end,
                },
              },
            },
          },
          documentation = {
            auto_show = true,
          },
        },
        snippets = {
          preset = 'luasnip',
          active = function(filter)
            local snippet = require("luasnip")
            local blink = require("blink.cmp")
            if snippet.in_snippet() and not blink.is_visible() then
              return true
            else
              if not snippet.in_snippet() and vim.fn.mode() == "n" then snippet.unlink_current() end
              return false
            end
          end,
        },
        sources = {
          default = { 'lsp', 'path', 'snippets', 'buffer', 'omni' },
          -- FIXME: Revisit these values
          providers = {
            path = {
              score_offset = 50,
            },
            lsp = {
              score_offset = 40,
            },
            snippets = {
              score_offset = 40,
            },
            cmdline = {
              score_offset = -100,
            },
          },
        },
      })
    end,
  }
}
