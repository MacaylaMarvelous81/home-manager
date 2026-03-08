{
  config,
  lib,
  wrappers,
  ...
}:
let
  cfg = config.usermod.term;
in
{
  options.usermod.term = {
    enable = lib.mkEnableOption "management of terminal emulators";
  };

  config = lib.mkIf cfg.enable {
    # programs.alacritty.enable = true;
    # programs.kitty.enable = true;
    # programs.foot.enable = true;

    usermod.portty = lib.mkIf config.usermod.portty.enable {
      termProgram = "${wrappers.foot}/bin/foot -e";
    };
    programs.niri = lib.mkIf config.usermod.niri.enable {
      settings = with config.lib.niri.actions; {
        binds = {
          "Mod+T".action = spawn "${wrappers.foot}/bin/foot";
        };
      };
    };
  };
}
