{
  pkgs ? import <nixpkgs> {},
  lib ? pkgs.lib,
  wrappers ? (import (fetchTarball "https://github.com/BirdeeHub/nix-wrapper-modules/archive/9a9f10119294b22de06f62b38cf7c41f12adbdc6.tar.gz") { inherit pkgs; }),
}:
let
  wrapperModules = import ./wrapperModules { inherit lib; };
in {
  atool = wrappers.wrappers.atool.wrap {
    inherit pkgs;
    tools.paths = {
      rar = "${ pkgs.rar }/bin/rar";
      unrar = "${ pkgs.unrar }/bin/unrar";
    };
  };
  rider = wrappers.lib.evalPackage({ ... }: {
    imports = [ wrapperModules.rider ];

    config = { inherit pkgs; };
  });
}
