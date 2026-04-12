{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usermod.waybar;
in
{
  options.usermod.waybar = {
    enable = lib.mkEnableOption "waybar wayland bar";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ ark-pixel-font ];
    fonts.fontconfig.enable = true;

    programs.waybar = {
      enable = true;
      systemd.enable = true;
      settings = {
        bar = {
          layer = "top";
          position = "top";
          modules-left = [
            "niri/window"
            "mpris"
            "custom/spacer"
            "wireplumber"
          ];
          modules-center = [
            "clock"
          ];
          modules-right = [
            "tray"
            "cpu"
            "custom/spacer"
            "memory"
            "custom/spacer"
            "disk"
            "custom/spacer"
            "network"
            "custom/spacer"
            "bluetooth"
          ];

          "niri/window" = {
            format = "> {title}";
          };
          mpris = {
            format = "<span color=\"#e3b872\">{player_icon}</span> {dynamic}";
            format-paused = "{status_icon} <i>{dynamic}</i>";
          };
          tray = {
            icon-size = 21;
            spacing = 10;
          };
          cpu = {
            format = " <span color=\"#e3b872\">cpu</span> {usage}";
            states = {
              warning = 80;
              critical = 95;
            };
          };
          memory = {
            format = "<span color=\"#e3b872\">mem</span> {used:0.1f}G/{total:0.1f}G";
          };
          disk = {
            format = "<span color=\"#e3b872\">dsk</span> {free}/{total}";
          };
          network = {
            format = "{icon} {ifname} ({ipaddr})";
            format-wifi = "{icon} {essid} ({ipaddr})";
          };
          bluetooth = {
            format = "<span color=\"#66c0f4\">bt</span> {status}";
            on-click = "${pkgs.blueman}/bin/blueman-manager";
          };
          "custom/spacer" = {
            format = " | ";
            tooltip = false;
          };
        };
      };
    };
  };
}
