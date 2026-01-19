{ config, lib, macaylamarvelous81-pkgs, ... }:
let
  cfg = config.usermod.portty;
in {
  options.usermod.portty = {
    enable = lib.mkEnableOption "installation of portty portal backend";
    termProgram = lib.mkOption {
      type = lib.types.str;
      default = "${ config.programs.kitty.package }/bin/kitty -e";
      description = "The command to use for the terminal emulator for portty to open";
    };
  };

  config = lib.mkIf cfg.enable {
    # No clear way to enable the service with this option, so it is commented out.
    # systemd.user.packages = [ macaylamarvelous81-pkgs.portty ];

    # the portty daemon is responsible for acquiring the D-Bus name, not
    # the systemd unit, so it is not automatically started by xdg-desktop-portal
    systemd.user.services.portty = {
      Unit = {
        Description = "Portty - XDG Desktop Portal for TTY";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${ macaylamarvelous81-pkgs.portty }/libexec/porttyd";
        Restart = "on-failure";
        RestartSec = 5;
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    xdg.portal = {
      config.niri = lib.mkIf config.usermod.niri.enable {
        "org.freedesktop.impl.portal.FileChooser" = [ "tty" ];
      };
      extraPortals = [ macaylamarvelous81-pkgs.portty ];
    };

    xdg.configFile = {
      "portty/config.toml".text = ''
        exec = "${ cfg.termProgram } ${ ./shell-wrapper.sh }"
      '';
    };
  };
}
