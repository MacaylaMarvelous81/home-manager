{ config, lib, ... }:
let
  cfg = config.usermod.term;
in {
  options.usermod.term = {
    enable = lib.mkEnableOption "management of terminal emulators";
  };

  config = lib.mkIf cfg.enable {
    programs.alacritty.enable = true;
  };
}
