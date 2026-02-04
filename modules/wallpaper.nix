{ config, pkgs, lib, ... }:
let
  cfg = config.usermod.wallpaper;
in {
  options.usermod.wallpaper = {
    enable = lib.mkEnableOption "manage wallpaper layer";
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.wallpaper = {
      Unit = {
        Description = "Wallpaper provided by linux-wallpaperengine";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "\"${ pkgs.linux-wallpaperengine }/bin/linux-wallpaperengine\" --assets-dir \"${ ../home-manager-private }/depot_431961_19812784/assets\" --silent --screen-root eDP-1 --bg \"${ ../home-manager-private }/Deathwing - Heroes of the Storm (unpacked)\"";
        Restart = "on-failure";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
