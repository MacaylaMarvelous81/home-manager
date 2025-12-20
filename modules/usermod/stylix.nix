{ config, lib, ... }:
let
  cfg = config.usermod.stylix;
in {
  options.usermod.stylix = {
    enable = lib.mkEnableOption "stylix usage";
  };

  config = lib.mkIf cfg.enable {
    stylix.enable = true;
  };
}
