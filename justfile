[private]
default:
    @just --list

test:
    nix flake update introdus && \
    nix build .#full && \
    result/bin/nvim-neovide
