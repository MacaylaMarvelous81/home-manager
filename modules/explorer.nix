{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.usermod.explorer;
in
{
  options.usermod.explorer = {
    enable = lib.mkEnableOption "file managers/explorers";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ lxqt.pcmanfm-qt ];

    programs.niri = lib.mkIf config.usermod.niri.enable {
      settings = with config.lib.niri.actions; {
        binds = {
          "Mod+E".action = spawn "${pkgs.lxqt.pcmanfm-qt}/bin/pcmanfm-qt";
        };
      };
    };
  };
}
