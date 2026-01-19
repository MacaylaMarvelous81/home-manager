{ config, pkgs, lib, wrappers, ... }:
let
  cfg = config.usermod.neovim;
in {
  options.usermod.neovim = {
    enable = lib.mkEnableOption "management of user neovim settings";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      wrappers.neovim
      wrappers.neovide
    ];

    home.sessionVariables = {
      EDITOR = "${ wrappers.neovim }/bin/nvim";
    };

    programs.niri = lib.mkIf config.usermod.niri.enable {
      settings = with config.lib.niri.actions; {
        binds = {
          "Mod+Z".action = spawn "${ wrappers.neovide }/bin/neovide";
        };
      };
    };
  };
}
