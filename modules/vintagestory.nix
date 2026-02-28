{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.usermod.vintagestory;
in
{
  options.usermod.vintagestory = {
    enable = lib.mkEnableOption "Vintage Story game";
  };

  config = lib.mkIf cfg.enable {
    usermod.unfree.pkgnames = [ "vintagestory" ];

    home.packages = with pkgs; [ vintagestory ];

    home.sessionVariables.VINTAGE_STORY = "${pkgs.vintagestory}/share/vintagestory";
  };
}
