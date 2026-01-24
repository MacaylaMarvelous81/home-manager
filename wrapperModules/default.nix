{
  pkgs ? import <nixpkgs> {},
  lib ? pkgs.lib,
}:
lib.pipe ./. [
  builtins.readDir
  (lib.filterAttrs (_: type: type == "directory"))
  (builtins.mapAttrs (
    name: _: import ./${ name }
  ))
]
