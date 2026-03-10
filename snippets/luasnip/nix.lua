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
    'mko',
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
}
