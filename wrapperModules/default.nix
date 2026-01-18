{
  pkgs ? import <nixpkgs> {},
  lib ? pkgs.lib,
  wlib ? (import (fetchTarball "https://github.com/BirdeeHub/nix-wrapper-modules/archive/b85202cf7822e358bb57aae56b6f51118947b24c.tar.gz") { inherit pkgs; }).lib,
}:
lib.pipe ./. [
  builtins.readDir
  (lib.filterAttrs (_: type: type == "directory"))
  (builtins.mapAttrs (
    name: _: (wlib.evalModule (import ./${ name })).config
  ))
]
