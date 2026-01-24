{
  pkgs ? import <nixpkgs> {},
  lib ? pkgs.lib,
  wrappers ? (import (fetchTarball "https://github.com/BirdeeHub/nix-wrapper-modules/archive/9a9f10119294b22de06f62b38cf7c41f12adbdc6.tar.gz") { inherit pkgs; }),
}:
let
  wrapperModules = import ./wrapperModules { inherit lib; };
in rec {
  atool = wrappers.wrappers.atool.wrap {
    inherit pkgs;
    tools.paths = {
      rar = "${ pkgs.rar }/bin/rar";
      unrar = "${ pkgs.unrar }/bin/unrar";
    };
  };
  neovide = wrappers.lib.evalPackage ({ ... }: {
    imports = [ wrapperModules.neovide ];

    config = {
      inherit pkgs;

      settings = {
        neovim-bin = "${ neovim }/bin/nvim";

        font = {
          normal = "FiraCode Nerd Font";
          size = 12;
        };
      };
    };
  });
  neovim = wrappers.lib.evalPackage ({ ... }: {
    imports =  [ wrapperModules.neovim ];

    config = { inherit pkgs; };
  });
}
