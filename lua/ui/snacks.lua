return {
  {
    'snacks.nvim',
    lazy = false,
    event = 'DeferredUIEnter',
    after = function(plugin)
      require('snacks').setup({
        dashboard = {
          enabled = true,
          width = 60,
          row = nil,
          col = nil,
          pane_gap = 4,
          autokeys = '1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ',
          wo = {
            relativenumber = false,
            number = false,
          },
          preset = {
            pick = nil,
            header = [[ 
                                   .,
                                   '��i�,   .
                                    l����0�, :.
                                   l��������i, :.
                                ,,m,���������l  '':
                              .i����������7*',i��,
                              l������7**''_xi�����: :.
                               *"" _""5�����7"__"7',_ '
                             ,,x',��g,"4��',��g, i�k.
                            :��� ��'"�� ��l ��'"�� l���
                         h7  4*" ��_,�� �7' ��_,�� ����: dS!
                           _,x��.'��7',,xi.'��7',���' ,:
                         ,�������m,"",n�����i,"",d7*'.�, ':.
                      . :������l 4��������������7 ,xi���i. :
                      . l�������i, �4��������7�_�i�������l  :
                    _il, 4��������i�,_�"""�_,�i���������7' .
                 ______ \_"'44�����7"______"47'______"`"_,di,:. .
        ]],
          },
          formats = {
            icon = function(item)
              if item.file and item.icon == 'file' or item.icon == 'directory' then
                return Snacks.dashboard.icon(item.file, item.icon)
              end
              return { item.icon, width = 2, hl = 'icon' }
            end,
            header = { '%s', align = 'left' },
            footer = { '%s', align = 'center' },
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
            -- {
            --   section = 'terminal',
            --   cmd = 'chafa ~/dev/nix/neovim/assets/jinteki.jpg --format symbols -s 50x50 -c 2; sleep .1',
            --   align = 'center',
            --   height = 25,
            --   width = 50,
            -- },
            { section = 'header' },
          },
        },
        -- picker/explorer
        -- FIXME: currently LSPs uses this but it may be worth replacing
        -- telescope with it as well
        picker = { enabled = true },
      })
    end,
  },
}
