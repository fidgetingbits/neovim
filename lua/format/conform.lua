return {
  {
    'conform.nvim',
    lazy = false,
    after = function(_)
      local conform = require('conform')

      conform.setup({
        formatters_by_ft = {
          -- Conform will run multiple formatters sequentially
          -- FIXME: switch to use treefmt
          lua = { 'stylua' },
          kdl = { 'kdlfmt' },
          python = { 'ruff' },
          nix = { 'nixfmt' },
          rust = { 'rustfmt' },
          sh = { 'shfmt', 'shellharden' },
          zsh = { 'shfmt', 'shellharden' },
          json = { 'fixjson', 'prettier' },
          yaml = { 'yamlfmt', 'prettier' },
          toml = { 'taplo' },
          -- Use a sub-list to run only the first available formatter
          -- javascript = { { "prettierd", "prettier" } },
        },
        formatters = {
          kdl = {
            command = 'kdlfmt',
            args = { 'format', '--kdl-version=v1', '-' },
            stdin = true,
          },
        },
        format_on_save = function(bufnr)
          -- Disable with a global or buffer-local variable
          if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
          end
          return { timeout_ms = 500, lsp_format = 'fallback' }
        end,
      })

      vim.api.nvim_create_user_command('FormatDisable', function(args)
        if args.bang then
          -- FormatDisable! will disable formatting just for this buffer
          vim.b.disable_autoformat = true
          vim.notify('Conform buffer auto-format disabled')
        else
          vim.g.disable_autoformat = true
          vim.notify('Conform global auto-format disabled')
        end
      end, {
        desc = 'Disable autoformat-on-save',
        bang = true,
      })
      vim.api.nvim_create_user_command('FormatEnable', function()
        vim.b.disable_autoformat = false
        vim.g.disable_autoformat = false
        vim.notify('Conform auto-format enabled')
      end, {
        desc = 'Re-enable autoformat-on-save',
      })
      vim.api.nvim_create_user_command('FormatToggle', function(args)
        if args.buffer then
          vim.b.disable_autoformat = not vim.b.disable_autoformat
          vim.notify(
            'Conform buffer auto-format ' .. (vim.b.disable_autoformat and 'disabled' or 'enabled')
          )
        elseif args.global then
          vim.g.disable_autoformat = not vim.g.disable_autoformat
          vim.notify(
            'Conform global auto-format ' .. (vim.g.disable_autoformat and 'disabled' or 'enabled')
          )
        else
          vim.b.disable_autoformat = not vim.b.disable_autoformat
          vim.g.disable_autoformat = not vim.g.disable_autoformat
          vim.notify(
            'Conform auto-format ' .. (vim.g.disable_autoformat and 'disabled' or 'enabled')
          )
        end
      end, {
        nargs = '?',
        desc = 'Toggle autoformat-on-save',
      })

      vim.keymap.set({ 'n', 'v' }, '<leader>FF', function()
        conform.format({
          lsp_fallback = true,
          async = false,
          timeout_ms = 1000,
        })
      end, { desc = '[F]ormat [F]ile' })

      vim.keymap.set(
        { 'n', 'v' },
        '<leader>Fb',
        '<cmd>FormatToggle buffer<CR>',
        { desc = '[Format] toggle buffer' }
      )
      vim.keymap.set(
        { 'n', 'v' },
        '<leader>Fg',
        '<cmd>FormatToggle global<CR>',
        { desc = '[Format] toggle global' }
      )
      vim.keymap.set({ 'n', 'v' }, '<leader>Ft', vim.cmd.FormatToggle, { desc = '[Format] toggle' })
    end,
  },
}
