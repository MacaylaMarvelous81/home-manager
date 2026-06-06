{ config, lib, ... }:
let
  cfg = config.usermod.neovim;
in
{
  options.usermod.neovim = {
    enable = lib.mkEnableOption "neovim module";
    neovide = lib.mkEnableOption "neovide";
  };

  config = lib.mkIf cfg.enable {
    programs.lazyvim.enable = true;

    programs.neovide = lib.mkIf cfg.neovide {
      enable = true;
    };

    programs.niri = lib.mkIf (cfg.neovide && config.usermod.niri.enable) {
      settings = with config.lib.niri.actions; {
        binds = {
          "Mod+Z".action = spawn "${config.programs.neovide.package}/bin/neovide";
        };
      };
    };
  };
}
