inputs:
{
  config,
  wlib,
  lib,
  pkgs,
  ...
}:
let
  configDir = "/dev/nix/neovim"; # relative to home
in
{
  imports = [
    inputs.introdus.wrapperModules.neovim
  ];
  # Extend the introdus neovim template with any additional functionality we want
  config = {
    settings = {
      baseConfig = "${inputs.introdus}/wrappers/neovim";
      # unwrappedConfig = lib.mkForce (
      #   lib.generators.mkLuaInline # lua
      #     "vim.uv.os_homedir() .. '${configDir}'"
      # );
    };

    nvim-lib.pluginInputs = [
      inputs
      inputs.introdus
    ];

    # NOTE: Specs are enabled by default
    specs = {
      # Extending existing spec from introdus
      ui = {
        data =
          lib.attrValues {
            inherit (pkgs.vimPlugins)
              scope-nvim # Per tabpage-scoped buffers
              ;
            inherit (config.nvim-lib.neovimPlugins)
              ansi
              ;
          }
          ++ lib.optionals config.settings.devMode (
            lib.attrValues {
              inherit (config.nvim-lib.neovimPlugins)
                lua-console
                ;
            }
          )
          ++ lib.optionals config.settings.terminalMode (
            lib.attrValues {
              inherit (pkgs.vimPlugins)
                toggleterm-nvim
                ;
            }
          );
      };
      theme = {
        data = lib.attrValues {
          inherit (pkgs.vimPlugins)
            catppuccin-nvim
            miasma-nvim
            lush-nvim
            ;
        };
      };
    };
  };
}
