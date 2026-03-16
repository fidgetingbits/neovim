inputs:
{
  config,
  wlib,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.introdus.wrapperModules.neovim
  ];
  # Extend the introdus neovim template with any additional functionality we want
  config = {
    settings.aliases = [
      "nv"
    ];
  };
}
