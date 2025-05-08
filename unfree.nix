{ nixpkgs, lib, config, pkgs, ... }:

{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steamcmd"
    "steam-unwrapped"
  ];

  home.packages = [
    pkgs.steamcmd
  ];
}
