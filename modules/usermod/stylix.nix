{ config, lib, ... }:
let
  cfg = config.usermod.stylix;
in {
  options.usermod.stylix = {
    enable = lib.mkEnableOption "stylix usage";
  };

  config = lib.mkIf cfg.enable {
    stylix = {
      enable = true;

      image = "${ ../../home-manager-private }/Deathwing - Heroes of the Storm (unpacked)/materials/be94bcb77b47e00d53bc0e7fe44a48c8_1_0_art.jpg";
      polarity = "dark";

      targets.firefox.profileNames = [ "default" ];
    };
  };
}
