# https://github.com/BirdeeHub/nix-wrapper-modules/blob/main/templates/neovim/README.md
{
  description = "Fidgeting Neovim";

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

    plugins-lua-console = {
      url = "github:yarospace/lua-console.nvim";
      # url = "path:/home/aa/dev/neovim/lua-console.nvim";
      flake = false;
    };

    plugins-telescope-toggleterm = {
      url = "github:da-moon/telescope-toggleterm.nvim";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      wrappers,
      flake-parts,
      introdus,
      ...
    }@inputs:
    let
      lib = nixpkgs.lib;
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ wrappers.flakeModules.wrappers ];
      systems = nixpkgs.lib.platforms.all;

      perSystem =
        { pkgs, config, ... }:
        {
          packages = {
            full = config.packages.neovim.wrap {
              settings = {
                devMode = true;
                neovide = true;
                terminalMode = true;
                unwrappedConfig = "/home/aa/dev/nix/neovim";
              };
            };
          };
        };

      flake.wrappers = {
        neovim = lib.modules.importApply ./module.nix (inputs // introdus.inputs);
        default = self.wrapperModules.neovim;
      };
    };
}
