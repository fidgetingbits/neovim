[private]
default:
    @just --list

neovide:
    nix flake update introdus && \
    nix build .#full && \
    result/bin/nvim-neovide
