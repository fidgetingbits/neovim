# https://github.com/BirdeeHub/nix-wrapper-modules/blob/main/templates/neovim/README.md
{
  description = "Fidgeting Neovim";

  outputs =
    {
      self,
      nixpkgs,
      wrappers,
      flake-parts,
      introdus,
      neovim-nightly-overlay,
      ...
    }@inputs:
    let
      inherit (nixpkgs) lib;
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ wrappers.flakeModules.wrappers ];
      systems = nixpkgs.lib.platforms.all;

      perSystem =
        {
          pkgs,
          config,
          ...
        }:
        {
          packages = {
            full = config.packages.neovim.wrap {
              package = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.neovim-debug;
              #package = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.neovim;
              settings = {
                devMode = true;
                neovide = true;
                terminalMode = true;
                unwrappedConfig = "/home/aa/dev/nix/neovim";
                baseConfig = lib.mkForce "/home/aa/dev/nix/introdus/aa/wrappers/neovim";
                # baseConfig = lib.mkForce "/home/aa/dev/nix/introdus/neovim-shared-config/wrappers/neovim";
              };
            };
            basic = config.packages.neovim.wrap {
              settings = {
                neovide = true;
              };
            };

          };
        };

      flake.wrappers = {
        neovim = lib.modules.importApply ./module.nix (inputs // introdus.inputs);
        default = self.wrapperModules.neovim;
      };
    };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    wrappers = {
      url = "github:BirdeeHub/nix-wrapper-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    # Shared wrapper modules and configs
    introdus = {
      # url = "git+ssh://git@codeberg.org/fidgetingbits/introdus?ref=aa";
      url = "path:///home/aa/dev/nix/introdus/aa";
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plugins-lua-console = {
      url = "github:yarospace/lua-console.nvim";
      # url = "path:/home/aa/dev/neovim/lua-console.nvim";
      flake = false;
    };

    plugins-telescope-toggleterm = {
      url = "github:da-moon/telescope-toggleterm.nvim";
      flake = false;
    };

    plugins-ansi = {
      url = "github:0xferrous/ansi.nvim";
      flake = false;
    };

    plugins-modes = {
      url = "github:mvllow/modes.nvim";
      flake = false;
    };

    plugins-neov-ime = {
      url = "github:sevenc-nanashi/neov-ime.nvim";
      flake = false;
    };
    plugins-haunt = {
      url = "github:TheNoeTrevino/haunt.nvim";
      flake = false;
    };
    plugins-screenkey = {
      url = "github:NStefan002/screenkey.nvim";
      flake = false;
    };
  };
}
