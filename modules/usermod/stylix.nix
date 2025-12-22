{ config, pkgs, lib, ... }:
let
  cfg = config.usermod.stylix;
  drago-cursor = pkgs.stdenvNoCC.mkDerivation {
    pname = "drago-cursor";
    version = "0-unstable-2023-07-16";

    src = ../../home-manager-private/drago-cursor.tar.gz;

    installPhase = ''
      mkdir -p $out/share/icons
      cp -r . $out/share/icons/drago-cursor
    '';
  };
in {
  options.usermod.stylix = {
    enable = lib.mkEnableOption "stylix usage";
  };

  config = lib.mkIf cfg.enable {
    stylix = {
      enable = true;

      image = "${ ../../home-manager-private }/Deathwing - Heroes of the Storm (unpacked)/materials/be94bcb77b47e00d53bc0e7fe44a48c8_1_0_art.jpg";
      polarity = "dark";

      cursor = {
        package = drago-cursor;
        name = "drago-cursor";
        size = 24;
      };

      icons = {
        enable = true;
        package = pkgs.papirus-icon-theme;
        light = "Papirus-Light";
        dark = "Papirus-Dark";
      };

      targets.firefox.profileNames = [ "default" ];
    };
  };
}
