{
  description = "Fidgetingbits' nix-wrapper config";

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
    # inputs.plugins-XXX = {
    #   url = "github:foo/bar";
    #   flake = false;
    # };
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
        { pkgs, ... }:
        {
          # wrappers.pkgs = pkgs; # choose a different `pkgs`
          # FIXME: This is already the default, so probably remove
          # https://github.com/BirdeeHub/nix-wrapper-modules/blob/cf2aca/parts.nix#L68
          wrappers.control_type = "exclude"; # | "build"  (default: "exclude")
          wrappers.packages = { };
        };
      flake.wrappers.default = nixpkgs.lib.modules.importApply ./module.nix inputs;
    };
}
