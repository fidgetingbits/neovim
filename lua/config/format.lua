require('lze').load {
  {
    "conform.nvim",
    for_cat = 'format',
    -- cmd = { "" },
    -- event = "",
    -- ft = "",
    keys = {
      { "<leader>FF", desc = "[F]ormat [F]ile" },
    },
    -- colorscheme = "",
    after = function (plugin)
      local conform = require("conform")

      conform.setup({
        formatters_by_ft = {
          -- NOTE: download some formatters in lspsAndRuntimeDeps
          -- and configure them here
          -- go = { "gofmt", "golint" },
          -- templ = { "templ" },
          -- Conform will run multiple formatters sequentially
          lua = { "stylua" },
          python = { "ruff" },
          nix = { "nixfmt" },
          rust = { "rustfmt" },
          sh = { "shfmt", "shellharden" },
          zsh = { "shfmt", "shellharden" },
          json = { 'prettier' },
          yaml = { 'prettier', 'yamlfmt' },
          toml = { 'taplo' },
          -- Use a sub-list to run only the first available formatter
          -- javascript = { { "prettierd", "prettier" } },
        },
      })

      vim.keymap.set({ "n", "v" }, "<leader>FF", function()
        conform.format({
          lsp_fallback = true,
          async = false,
          timeout_ms = 1000,
        })
      end, { desc = "[F]ormat [F]ile" })

    end,
  },
}
-- Setup format on save
vim.api.nvim_create_autocmd("LspAttach", {
callback = function(args)
  local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
  if client:supports_method('textDocument/formatting') then
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = args.buf,
      callback = function()
        -- Allow per-project shut off via vim.o.exrc files
        -- FIXME: Add a function to write such a file to the root of a project
        if vim.b.disable_autoformat then
          return
        end

        vim.lsp.buf.format({
          async = false,
          bufnr = args.buf,
          id = client.id
        })
      end,
    })
  end
end,
})
