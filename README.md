# Fidgeting Neovim

A config based on
[nix-wrappers-modules](https://github.com/BirdeeHub/nix-wrapper-modules/blob/main/templates/neovim/README.md).
It is templated off some other examples of people I happened to see moving
over, such as [here](https://github.com/pinksteven/stevenvim).

## Building

To build a specific configuration use `nix build .#<package>`. For example,
`nix build .#full` will build a package with all options enabled.

## Resources

* [neovim wrapper template](https://github.com/BirdeeHub/nix-wrapper-modules/tree/main/templates/neovim)
* [neovim wrapper module](https://github.com/BirdeeHub/nix-wrapper-modules/tree/cf2acacb/wrapperModules/n/neovim)
