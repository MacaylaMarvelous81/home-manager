{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.usermod.anyrun;
in
{
  options.usermod.anyrun = {
    enable = lib.mkEnableOption "anyrun config";
  };

  config = lib.mkIf cfg.enable {
    programs.anyrun = {
      enable = true;
      config = {
        plugins = [
          "${config.programs.anyrun.package}/lib/libapplications.so"
          "${config.programs.anyrun.package}/lib/librink.so"
          "${config.programs.anyrun.package}/lib/libdictionary.so"
          "${config.programs.anyrun.package}/lib/libactions.so"
        ];
      };
    };

    programs.niri = lib.mkIf config.programs.niri.enable {
      settings = with config.lib.niri.actions; {
        binds = {
          "Mod+Space".action = spawn "${config.programs.anyrun.package}/bin/anyrun";
          # "Mod+L".action =
          #   spawn "${config.programs.rofi.package}/bin/rofi" "-show" "power-menu" "-modi"
          #     "power-menu:${pkgs.rofi-power-menu}/bin/rofi-power-menu";
        };
      };
    };
  };
}
