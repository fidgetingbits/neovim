# This module extends defaults that are part of the introdus shared wrapper.
# See https://codeberg.org/fidgetingbits/introdus/src/branch/aa/wrappers/neovim
# for the shared settings
inputs:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  # FIXME: Make this work...
  # configSource = lib.introdus.neovim.configSource ./.;
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

  config = {
    settings = {
      # Introdus as the base config
      baseConfig = "${inputs.introdus}/wrappers/neovim";
      # When not in using hot reloading, this flakes /nix/store folder is the
      # config extending introdus
      wrappedConfig = "${configSource}";
    };

    nvim-lib.pluginInputs = [
      inputs
      inputs.introdus
    ];

    # NOTE: Specs are enabled by default
    specs = {

      # LLM tooling
      ai = {
        after = [ "ui" ];
        enable = config.settings.devMode;
        lazy = true;
        data = lib.attrValues {
          inherit (pkgs.vimPlugins)
            codecompanion-spinner-nvim
            copilot-lua
            copilot-lsp # NES functionality
            ;
        };
      };

      # Extending existing spec from introdus
      ui = {
        data =
          lib.attrValues {
            inherit (pkgs.vimPlugins)
              scope-nvim # Per tabpage-scoped buffers
              nvim-highlight-colors
              ;
            inherit (config.nvim-lib.neovimPlugins)
              ansi
              modes
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
      editing = {
        data = lib.attrValues { inherit (pkgs.vimPlugins) nvim-early-retirement; };
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
