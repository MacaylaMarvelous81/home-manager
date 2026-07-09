{
  config,
  lib,
  ...
}:
let
  cfg = config.usermod.dunst;
in
{
  options.usermod.dunst = {
    enable = lib.mkEnableOption "dunst";
  };

  config = lib.mkIf cfg.enable {
    services.dunst = {
      enable = true;
      settings = {
        global = lib.mkMerge [
          {
            mouse_left_click = "context,close_current";
            mouse_middle_click = "close_all";
            mouse_right_click = "close_current";
          }
          (lib.mkIf config.programs.rofi.enable {
            dmenu = "${config.programs.rofi.package}/bin/rofi -dmenu -p dunst";
          })
        ];
      };
    };
  };
}
