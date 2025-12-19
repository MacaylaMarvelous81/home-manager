{ config, lib, ... }:
let
  cfg = config.usermod.shell;
in {
  options.usermod.shell = {
    enable = lib.mkEnableOption "shell management";
  };

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      defaultKeymap = "emacs";
    };
    programs.bash.enable = true;
  };
}
