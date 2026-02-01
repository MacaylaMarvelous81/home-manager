{ config, lib, wrappers, ... }:
let
  cfg = config.usermod.atool;
in {
  options.usermod.atool = {
    enable = lib.mkEnableOption "manage atool and its configuration";
  };

  config = lib.mkIf cfg.enable {
    usermod.unfree.pkgnames = [
      "rar"
      "unrar"
    ];
    home.packages = [ wrappers.atool ];
  };
}
