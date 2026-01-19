{ config, lib, wrappers, ... }:
let
  cfg = config.usermod.atool;
in {
  options.usermod.atool = {
    enable = lib.mkEnableOption "manage atool and its configuration";
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "rar"
      "unrar"
    ];
    home.packages = [ wrappers.atool ];
  };
}
