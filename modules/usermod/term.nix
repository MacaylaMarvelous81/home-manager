{ config, lib, ... }:
let
  cfg = config.usermod.term;
in {
  options.usermod.term = {
    enable = lib.mkEnableOption "management of terminal emulators";
  };

  config = lib.mkIf cfg.enable {
    # programs.alacritty.enable = true;
    # programs.kitty.enable = true;
    programs.foot.enable = true;

    usermod.portty = lib.mkIf config.usermod.portty.enable {
      termProgram = "${ config.programs.foot.package }/bin/foot -e";
    };
    programs.noctalia-shell = lib.mkIf config.usermod.noctalia-shell.enable {
      settings.appLauncher.terminalCommand = "${ config.programs.foot.package }/bin/foot -e";
    };
    programs.niri = lib.mkIf config.usermod.niri.enable {
      settings = with config.lib.niri.actions; {
        binds = {
          "Mod+T".action = spawn "${ config.programs.foot.package }/bin/foot";
        };
      };
    };
  };
}
