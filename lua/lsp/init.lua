-- NOTE: This config uses lzextras.lsp handler
-- https://github.com/BirdeeHub/lzextras?tab=readme-ov-file#lsp-handler
-- Because we have the paths, we can set a more performant fallback function
-- for when you don't provide a filetype to trigger on yourself.
-- If you do provide a filetype, this will never be called.

nixInfo.lze.h.lsp.set_ft_fallback(function(name)
  local lspcfg = nixInfo.get_nix_plugin_path('nvim-lspconfig')
  if lspcfg then
    local ok, cfg = pcall(dofile, lspcfg .. '/lsp/' .. name .. '.lua')
    return (ok and cfg or {}).filetypes or {}
  else
    -- the less performant thing we are trying to avoid at startup
    return (vim.lsp.config[name] or {}).filetypes or {}
  end
end)

return {
  {
    'nvim-lspconfig',
    lazy = false, -- FIXME: on_attach not firing
    on_require = { 'lspconfig' },
    -- NOTE: will run for all specs with type(plugin.lsp) == table
    -- when their filetype trigger loads them
    lsp = function(plugin)
      vim.lsp.config(plugin.name, plugin.lsp or {})
      vim.lsp.enable(plugin.name)
    end,
    before = function(_)
      vim.lsp.config('*', {
        on_attach = function(_, bufnr)
          local nmap = function(keys, func, desc)
            if desc then
              desc = 'LSP: ' .. desc
            end

            vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
          end

          local l = '<leader>l'
          local b = require('telescope.builtin')
          -- stylua: ignore start
          nmap(l .. 'r',  vim.lsp.buf.rename, '[R]ename')
          nmap(l .. 'ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
          nmap('gd',      vim.lsp.buf.definition, '[G]oto [D]efinition')
          nmap(l .. 'd',  vim.lsp.buf.definition, 'Goto [D]efinition')
          nmap('gr',      function() b.lsp_references() end , '[G]oto [R]eferences')
          nmap(l .. 'r',  function() b.lsp_references() end , 'Goto [R]eferences')
          nmap(l .. 'I',  function() b.lsp_implementations() end, 'Goto [I]mplementation')
          nmap(l .. 'ds', function() b.lsp_document_symbols() end, '[D]ocument [S]ymbols')
          nmap(l .. 'ws', function() b.lsp_dynamic_workspace_symbols() end, '[W]orkspace [S]ymbols')
          nmap(l .. 'td', vim.lsp.buf.type_definition, '[T]ype [D]efinition')
          nmap(l .. 'k',  vim.lsp.buf.hover, 'Hover Documentation')
          nmap(l .. 'K',  vim.lsp.buf.signature_help, 'Signature Documentation')
          nmap(l .. 'D',  vim.lsp.buf.declaration, 'Goto [D]eclaration')
          nmap(l .. 'wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
          nmap(l .. 'wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
          nmap(l .. 'wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, '[W]orkspace [L]ist Folders')
          -- stylua: ignore end

          -- NOTE: See conform.lua for formatting with lsp fallback
        end,
      })
    end,
  },
  { import = 'lsp.bash' },
  { import = 'lsp.lua' },
  { import = 'lsp.clang' },
  { import = 'lsp.just' },
  { import = 'lsp.markdown' },
  { import = 'lsp.nix' },
  { import = 'lsp.python' },
}
