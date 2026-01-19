{ config, macaylamarvelous81-pkgs, lib, ... }:
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
    systemd.user.packages = [ macaylamarvelous81-pkgs.portty ];

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
