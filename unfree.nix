{ nixpkgs, lib, config, pkgs, isDarwin, ... }:

{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steamcmd"
    "steam-unwrapped"
  ];

  home.packages = [] ++ lib.optionals (!isDarwin) [
    pkgs.steamcmd
  ];
}
