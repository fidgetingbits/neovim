inputs:
{
  config,
  wlib,
  lib,
  pkgs,
  ...
}:
{

  imports = [ wlib.wrapperModules.neovim ];
  config.settings.config_directory = ./.;

  # NOTE: Specs are enabled by default
  config.specs.core = {
    data = lib.attrValues {
      inherit (pkgs.vimPlugins)
        lze
        lzextras
        vim-repeat
        plenary-nvim
        nvim-notify
        nvim-web-devicons
        nvim-lspconfig
        # FIXME: core?
        nvim-lint
        ;
    };

    extraPackages = lib.attrValues {
      inherit (pkgs)
        universal-ctags
        ripgrep
        fd
        tree-sitter
        ;
    };
  };

  config.specs.search = {
    after = [ "core" ];
    lazy = true;
    data = lib.attrValues {
      inherit (pkgs.vimPlugins)
        telescope-nvim
        telescope-fzf-native-nvim
        telescope-ui-select-nvim
        flash-nvim
        ;
    };
  };

  config.specs.ui = {
    after = [ "core" ];
    lazy = true;
    data = lib.attrValues {
      inherit (pkgs.vimPlugins)
        catppuccin-nvim
        fidget-nvim
        lualine-nvim
        neo-tree-nvim
        trouble-nvim
        zen-mode-nvim
        snacks-nvim
        which-key-nvim
        ;
    };
  };

  # config.specs.development = {
  #   after = [ "development" ];
  #   lazy = true;
  #   enable = false;
  #   data = lib.attrValues {
  #     inherit (pkgs.vimplugins)
  #       ;
  #   };
  # };

  config.specs.format = {
    after = [ "core" ];
    lazy = true;
    enable = false;
    data = lib.attrValues {
      inherit (pkgs.vimPlugins)
        conform-nvim
        ;
    };
    extraPackages = lib.attrValues {
      inherit (pkgs)
        kdlfmt
        shfmt
        shellharden
        nixfmt
        rustfmt
        ruff
        yamlfmt
        prettier
        taplo # toml
        bash-language-server
        just-lsp
        marksman # markdown
        ;
    };
  };

  # config.specs.lint = {
  #   enable = false;
  #   # extraPackages = {
  #   #   inherit (pkgs)
  #   #     ;
  #   # };
  # };

  # https://birdeehub.github.io/nix-wrapper-modules/neovim.html#tips-and-tricks
  config.specMods =
    {
      parentSpec ? null,
      parentOpts ? null,
      parentName ? null,
      config,
      ...
    }:
    {
      # add an extraPackages field to the specs themselves
      options.extraPackages = lib.mkOption {
        type = lib.types.listOf wlib.types.stringable;
        default = [ ];
        description = "An extraPackages spec field to put packages to suffix to the PATH";
      };
    };
  config.extraPackages = config.specCollect (acc: v: acc ++ (v.extraPackages or [ ])) [ ];

  options.settings.neovide = lib.mkOption {
    type = lib.types.bool;
    default = true;
  };
  # Build a neovide wrapper
  config.hosts.neovide.nvim-host.enable = config.settings.neovide;

  # Inform lua which top level specs are enabled
  options.settings.cats = lib.mkOption {
    readOnly = true;
    type = lib.types.attrsOf lib.types.bool;
    default = lib.mapAttrs (_: v: v.enable) config.specs;
  };

  options.nvim-lib.neovimPlugins = lib.mkOption {
    readOnly = true;
    type = lib.types.attrsOf wlib.types.stringable;
    # Makes plugins autobuilt from our inputs available with
    # `config.nvim-lib.neovimPlugins.<name_without_prefix>`
    default = config.nvim-lib.pluginsFromPrefix "plugins-" inputs;
  };

  # This is from the official template and allows you to build plugins
  # that aren't in nixpkgs yet.
  options.nvim-lib.pluginsFromPrefix = lib.mkOption {
    type = lib.types.raw;
    readOnly = true;
    default =
      prefix: inputs:
      lib.pipe inputs [
        builtins.attrNames
        (builtins.filter (s: lib.hasPrefix prefix s))
        (map (
          input:
          let
            name = lib.removePrefix prefix input;
          in
          {
            inherit name;
            value = config.nvim-lib.mkPlugin name inputs.${input};
          }
        ))
        builtins.listToAttrs
      ];
  };
}
