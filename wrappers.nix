{
  pkgs ? import <nixpkgs> {},
  lib ? pkgs.lib,
  wlib ? (import (fetchTarball "https://github.com/BirdeeHub/nix-wrapper-modules/archive/b85202cf7822e358bb57aae56b6f51118947b24c.tar.gz") { inherit pkgs; }).lib,
}:
let
  wrappedModules = import ./wrapperModules { inherit lib wlib; };
in rec {
  neovim = wrappedModules.neovim.wrap { inherit pkgs; };
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
}
