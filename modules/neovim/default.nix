{ config, pkgs, lib, wrappers, wrappedModules, ... }:
let
  cfg = config.usermod.neovim;
  neovim = wrappedModules.neovim.wrap { inherit pkgs; };
in {
  options.usermod.neovim = {
    enable = lib.mkEnableOption "management of user neovim settings";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      neovim
      (wrappedModules.neovide.wrap {
        inherit pkgs;
        neovim-bin = "${ neovim }/bin/nvim";
      })
    ];

    home.sessionVariables = {
      EDITOR = "${ neovim }/bin/nvim";
    };

    programs.niri = lib.mkIf config.usermod.niri.enable {
      settings = with config.lib.niri.actions; {
        binds = {
          "Mod+Z".action = spawn "${ wrappers.neovim.package }/bin/neovide";
        };
      };
    };
  };
}
