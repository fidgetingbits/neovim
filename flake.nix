# See https://github.com/BirdeeHub/nix-wrapper-modules/blob/main/templates/neovim/README.md
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

    ###
    # Neovim plugins from outside nixpkgs, either for fetching latest source or
    # because there is no package yet. See nvim-lib.neovimPlugins in module.nix
    ###
    plugins-nvim-toggler = {
      url = "github:nguyenvukhang/nvim-toggler";
      flake = false;
    };
    plugins-nvim-better-n = {
      url = "github:jonatan-branting/nvim-better-n";
      flake = false;
    };
    plugins-lua-console = {
      url = "github:yarospace/lua-console.nvim";
      # url = "path:/home/aa/dev/neovim/lua-console.nvim";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      wrappers,
      flake-parts,
      ...
    }@inputs:
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
              };
            };
          };
        };

      flake.wrappers = {
        neovim = nixpkgs.lib.modules.importApply ./module.nix inputs;
        default = self.wrapperModules.neovim;
      };
    };
}
