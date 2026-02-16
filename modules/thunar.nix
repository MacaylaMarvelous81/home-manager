{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.usermod.thunar;
in
{
  options.usermod.thunar = {
    enable = lib.mkEnableOption "Thunar file manager";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ thunar ];

    programs.niri = lib.mkIf config.usermod.niri.enable {
      settings = with config.lib.niri.actions; {
        binds = {
          "Mod+E".action = spawn "${pkgs.thunar}/bin/thunar";
        };
      };
    };
  };
}
