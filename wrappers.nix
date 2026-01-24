{
  pkgs ? import <nixpkgs> {},
  lib ? pkgs.lib,
  wrappers ? (import (fetchTarball "https://github.com/BirdeeHub/nix-wrapper-modules/archive/9a9f10119294b22de06f62b38cf7c41f12adbdc6.tar.gz") { inherit pkgs; }),
}:
let
  wrappedModules = import ./wrapperModules {
    inherit lib;
    wlib = wrappers.lib;
  };
in rec {
  atool = wrappers.wrappedModules.atool.wrap {
    inherit pkgs;
    tools.paths = {
      rar = "${ pkgs.rar }/bin/rar";
      unrar = "${ pkgs.unrar }/bin/unrar";
    };
  };
  neovide = wrappedModules.neovide.wrap {
    inherit pkgs;
    settings = {
      neovim-bin = "${ neovim }/bin/nvim";

      font = {
        normal = "FiraCode Nerd Font";
        size = 12;
      };
    };
  };
  neovim = wrappedModules.neovim.wrap { inherit pkgs; };
}
