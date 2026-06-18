[private]
default:
    @just --list

neovide:
    export NIXPKGS_ALLOW_UNFREE=1 && \
    nix flake update introdus && \
    nix build --impure .#full && \
    result/bin/nvim-neovide
