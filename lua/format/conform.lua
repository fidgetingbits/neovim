return {
  {
    "conform.nvim",
    lazy = false,
    after = function(plugin)
      local conform = require("conform")

      conform.setup({
        formatters_by_ft = {
          -- Conform will run multiple formatters sequentially
          lua = { "stylua" },
          kdl = { "kdlfmt" },
          python = { "ruff" },
          nix = { "nixfmt" },
          rust = { "rustfmt" },
          sh = { "shfmt", "shellharden" },
          zsh = { "shfmt", "shellharden" },
          json = { "prettier" },
          yaml = { "prettier", "yamlfmt" },
          toml = { "taplo" },
          -- Use a sub-list to run only the first available formatter
          -- javascript = { { "prettierd", "prettier" } },
        },

        -- FIXME: Add a toggle that allows disabling formatting on some projects
        -- https://github.com/stevearc/conform.nvim/blob/master/doc/recipes.md#command-to-toggle-format-on-save
        format_on_save = {
          -- These options will be passed to conform.format()
          timeout_ms = 500,
          lsp_format = "fallback",
        },
      })

      vim.keymap.set({ "n", "v" }, "<leader>FF", function()
        conform.format({
          lsp_fallback = true,
          async = false,
          timeout_ms = 1000,
        })
      end, { desc = "[F]ormat [F]ile" })

      -- Setup format on save
      -- vim.api.nvim_create_autocmd("LspAttach", {
      --   callback = function(args)
      --     local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
      --     if client:supports_method("textDocument/formatting") then
      --       vim.api.nvim_create_autocmd("BufWritePre", {
      --         buffer = args.buf,
      --         callback = function()
      --           -- Allow per-project shut off via vim.o.exrc files
      --           -- FIXME: Add a function to write such a file to the root of a project
      --           if vim.b.disable_autoformat then
      --             return
      --           end
      --
      --           vim.lsp.buf.format({
      --             async = false,
      --             bufnr = args.buf,
      --             id = client.id,
      --           })
      --         end,
      --       })
      --     end
      --   end,
      -- })
    end,
  },
}
