{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.usermod.rofi;
in
{
  options.usermod.rofi = {
    enable = lib.mkEnableOption "rofi launcher";
  };

  config = lib.mkIf cfg.enable {
    programs.rofi.enable = true;

    programs.niri = lib.mkIf config.usermod.rofi.enable {
      settings = with config.lib.niri.actions; {
        binds = {
          "Mod+Space".action =
            spawn "${config.programs.rofi.package}/bin/rofi" "-show" "combi" "-modes" "combi" "-combi-modes"
              "window,drun,run"
              "toggle";
          "Mod+L".action =
            spawn "${config.programs.rofi.package}/bin/rofi" "-show" "power-menu" "-modi"
              "power-menu:${pkgs.rofi-power-menu}/bin/rofi-power-menu";
        };
      };
    };
  };
}
