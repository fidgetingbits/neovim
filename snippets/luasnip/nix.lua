-- FIXME: Make this use a dynamic node so we can use recursion
-- for composite types
local function nix_types(jump_index)
  return c(jump_index, {
    -- Primitives
    t('str'),
    t('bool'),
    t('int'),
    t('path'),
    t('package'),
    t('anything'),

    -- Composite Types
    sn(nil, { t('listOf '), i(1, 'type') }),
    sn(nil, { t('attrsOf '), i(1, 'type') }),
    sn(nil, { t('nullOr '), i(1, 'type') }),
    sn(nil, { t('uniq '), i(1, 'type') }),

    -- Submodules
    sn(nil, { t('submodule { options = { '), i(1), t(' }; }') }),

    -- Numeric ranges/specialized
    t('port'),
    sn(nil, { t('ints.between '), i(1, '0'), t(' '), i(2, '65535') }),
    sn(nil, { t('enum [ '), i(1), t(' ]') }),

    -- Functions
    sn(nil, { t('functionTo '), i(1, 'type') }),
  })
end

return {
  s('typ', {
    t({ 'lib.types.' }),
    nix_types(1),
  }),
  s(
    { trig = 'mko', desc = 'mkOption of selectable type' },
    fmt(
      [[
      {} = lib.mkOption {{
        type = lib.types.{};
        default = {};
        example = {};
        description = "{}";
      }};
    ]],
      {
        i(1, 'var'),
        nix_types(2),
        i(3, 'val'),
        i(4, 'example'),
        i(5, 'description'),
      }
    )
  ),

  s(
    {
      trig = 'mkob',
      desc = 'mkOption of type boolean',
    },
    fmt(
      [[
      {} = lib.mkOption {{
        type = lib.types.bool;
        default = {};
        example = false; 
        description = "{}";
      }};
    ]],
      {
        i(1, 'var'),
        c(2, { t('true'), t('false') }),
        i(3, 'description'),
      }
    )
  ),

  s(
    { trig = 'wsa', desc = 'writeShellApplication' },
    fmt(
      [[
      {} = pkgs.writeShellApplication {{
        name = "{}";
        runtimeInputs = lib.attrValues {{
          inherit (pkgs)
          {}
          ;
        }};
        text = {};
      }};
      ]],
      {
        f(function(args)
          return args[1][1]
        end, { 1 }),
        i(1, 'name'),
        i(2, 'hello'),
        c(3, {
          sn(
            nil,
            fmt(
              [[
              # bash 
                ''
                  {}
                ''
              ]],
              { i(1) }
            )
          ),
          sn(nil, fmt('lib.readFile ./{}', { i(1, 'file') })),
          t(''),
        }),
      }
    )
  ),

  s(
    'pkglist',
    fmt(
      [[
      lib.attrValues {{
        inherit({})
          {}
        ;
      }};
    ]],
      {
        i(1, 'pkgs'),
        i(2, 'hello'),
      }
    )
  ),
}
