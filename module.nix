inputs:
{
  config,
  wlib,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.introdus.wrapperModules.neovim
  ];
  # Extend the introdus neovim template with any additional functionality we want
  config = {
    settings.extraConfig = "${inputs.introdus}/wrappers/neovim";

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
              catppuccin-nvim
              scope-nvim # Per tabpage-scoped buffers
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
    };

  };
}
