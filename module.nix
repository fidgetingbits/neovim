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
  # This duplicates introdus, so could just use a function so the files/folders
  # don't need to keep synced
  configSource = lib.fileset.toSource {
    root = ./.;
    fileset =
      map (p: lib.optional (builtins.pathExists p) p) [
        ./init.lua
        ./lua
        ./after
        ./plugin
        ./snippets
      ]
      |> lib.flatten
      |> lib.fileset.unions;
  };
in
{
  imports = [
    inputs.introdus.wrapperModules.neovim
  ];
  # Extend the introdus neovim template with any additional functionality we want
  config = {
    settings = {
      # Introdus is the base config we build on
      baseConfig = "${inputs.introdus}/wrappers/neovim";
      # When not in dev-mode, the neovim-wrapper's /nix/store folder is our
      # config extending introdus
      wrappedConfig = "${configSource}";
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
