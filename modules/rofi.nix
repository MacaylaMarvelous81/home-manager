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
    programs.rofi = {
      enable = true;
      theme =
        let
          inherit (config.lib.formats.rasi) mkLiteral;
        in
        {
          window = {
            border = 2;
            border-radius = 12;
          };
          listview = {
            border-radius = 10;
            border = 2;
            padding = 20;
            margin = mkLiteral "20px 30px 30px 30px";
            spacing = mkLiteral "0.3em";
          };
          element = {
            spacing = mkLiteral "0.5em";
            children = map mkLiteral [
              "element-icon"
              "element-text"
            ];
          };
        };
    };

    programs.niri = lib.mkIf config.programs.niri.enable {
      settings = with config.lib.niri.actions; {
        binds = {
          "Mod+Space".action = spawn "${config.programs.rofi.package}/bin/rofi" "-show" "drun";
          "Mod+L".action =
            spawn "${config.programs.rofi.package}/bin/rofi" "-show" "power-menu" "-modi"
              "power-menu:${pkgs.rofi-power-menu}/bin/rofi-power-menu";
        };
      };
    };
  };
}
