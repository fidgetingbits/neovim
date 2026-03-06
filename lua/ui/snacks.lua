-- FIXME: lifted from EM
return {
  {
    'snacks.nvim',
    lazy = false,
    event = 'DeferredUIEnter',
    after = function(plugin)
      require('snacks').setup({
        -- Only showing enabled tools.
        -- See https://github.com/folke/snacks.nvim?tab=readme-ov-file#-features
        -- for available tools
        -- FIXME: seriously consider the following:
        -- GitHub CLI integration
        -- gh = { enabled = true },
        -- Gitbrowse
        -- gitbrowse = { enabled = true },
        -- Image viewer
        -- image = { enabled = true},
        -- Quick load
        -- quickfile = { enabled = true },

        -- prevent lsp attaching to big files. default is 1.5MB
        bigfile = { enabled = true },

        -- dashboard
        dashboard = {
          enabled = true,
          width = 60,
          row = nil,
          col = nil,
          pane_gap = 4,
          --NOTE: Use the actual binds instead of this shit.
          -- autokeys = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
          preset = {
            pick = nil,
            keys = {
              {
                icon = ' ',
                desc = 'New File    :ene',
                -- key = "n",
                -- action = ":ene | startinsert"
              },
              {
                icon = ' ',
                desc = 'Find File   <leader>ff',
                -- key = "f",
                -- action = ":Telescope find_files",
              },
              {
                icon = ' ',
                desc = 'Find Buffer   <leader>fb',
                -- key = "b",
                -- action = ":Telescope buffers",
              },
              {
                icon = ' ',
                desc = 'Live grep   <leader>fg',
                -- key = "g",
                -- action = ":Telescope live_grep",
              },
              {
                icon = ' ',
                desc = 'Recent Files    <leader>fr',
                -- key = "r",
                -- action = ":Telescope oldfiles",
              },
              {
                icon = '󰮥 ',
                desc = 'Help tags     <leader>fh',
                -- key = "r",
                -- action = ":Telescope help_tags",
              },
            },
            header = [[
                           ..',;:::::::;,'..
                     .':loollllc:::::::clllllol;.
                  .coooc;..                 .';lool;.
               .cdoc'.                           .,ldo:.
             ,odc.               .;;,,,,,';odlcll:'..,oxl'
           ,dd;       .,;;::'. .lXWWWWWWWNWWWMWWWWNO:. .cxo.
         .dx;   ..'';xXWWWWWN0k0NWWMWWWWWWWWWWWWWNXNWXk:..lkc.
        ;ko.   :0XNNNWWWWWMWWWMMWWWWWWNWXkxOXWWNOo:,;lo:.  'xx'
       ck:     cNWWWWWWMMMWWW0dkNWWWNO0Xl'lx0NOdk0Kdod;.    .ok,
      lO;      :XMWMMWWWMMWWWx..;l:;,cOXx:,'kXdxNWMMMWNKo.    lO,
     :O;       ;doollkXWMMWMWKo.     .;OKllOKdd0XWMMWWWXo.     oO'
    'Ol               .,:cloxOk:,,;;dKKX0dxkl'oNWWWMXo:;,.     .xx.
    ok.                 'do'.'::loxOXWKk; 'd0KNWWWWWNx.         ;0:
   'Ol                 .oXWx.  .;:;:oKWx..dNWWMMWWWXOl.         .xx.
   :0;                  ..;c:;,,:dkxokNX:.kWWMMMWWNd..:x0x,      lO'
   lO'                 ,xdo:..    ,lco0WXo;oXMWMMWXc.oNWWNOl.    :0,
   lO'                .okk00o'''     .'cKW0OKx::c:. .dWWKl'.     :0;
   c0,                    .lXX0l        oWWXkoolc::;:ll,.        cO'
   ,0c                     .',cdd;..   ;0WXxldl'...;:.';.        dk.
   .xx.                        .cOxoxkOXWXkdoc:cclol;           'Ol
    :0:                          .lOXWMXo,';coo;...             oO.
     ok.                        .cOXNNx'                       :O:
     .xx.                     .cKWWMXl.                       ,Ol
      .xx.                   .dNWWXOc                        ;kl
       .ok,        .,;cloddxx0NWWMNK0kkxddolc:,..          .ck:
         ;ko.   .oOXWWWMWWMMMMWMMWWWMMWMMMMMWWWX0x'       'dx'
          .lkl. .cxOKNWWMWMMMWWMMWMMMWWWWWMWWNX0xl.     'ox:.
            .oxl'   ..,;:clloooddddoooollc:;,'..      ,oxc.
              .cddc'                              .,ldo;.
                 'cool:'.                     .,codo:.
                    .,cooolc:;''.......',;:lolloc'.
                         .';clllllllllllll:;'.
]],
          },
          formats = {
            icon = function(item)
              if item.file and item.icon == 'file' or item.icon == 'directory' then
                return Snacks.dashboard.icon(item.file, item.icon)
              end
              return { item.icon, width = 2, hl = 'icon' }
            end,
            footer = { '%s', align = 'center' },
            header = { '%s', align = 'center' },
            file = function(item, ctx)
              local fname = vim.fn.fnamemodify(item.file, ':~')
              fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
              if #fname > ctx.width then
                local dir = vim.fn.fnamemodify(fname, ':h')
                local file = vim.fn.fnamemodify(fname, ':t')
                if dir and file then
                  file = file:sub(-(ctx.width - #dir - 2))
                  fname = dir .. '/…' .. file
                end
              end
              local dir, file = fname:match('^(.*)/(.+)$')
              return dir and { { dir .. '/', hl = 'dir' }, { file, hl = 'file' } }
                or { { fname, hl = 'file' } }
            end,
          },
          sections = {
            { section = 'header' },
            -- FIXME: Disabled until I fix the hints
            -- { section = 'keys', gap = 1, padding = 1 },
          },
        },
        -- picker/explorer
        -- FIXME: currently LPSs uses this but it may be worth replacing
        -- telescope with it as well
        picker = { enabled = true },
      })
    end,
  },
}
