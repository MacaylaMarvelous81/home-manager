{ config, lib, ... }:
let
  cfg = config.usermod.nixvim;
in
{
  options.usermod.nixvim = {
    enable = lib.mkEnableOption "nixvim module";
    neovide = lib.mkEnableOption "neovide";
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      enable = true;
      imports = [ ../nixvim/config ];
    };

    programs.neovide = lib.mkIf cfg.neovide {
      enable = true;
    };

    programs.niri = lib.mkIf (cfg.neovide && config.usermod.niri.enable) {
      settings = with config.lib.niri.actions; {
        binds = {
          "Mod+Z".action = spawn "${config.programs.neovide.package}/bin/neovide";
        };
      };
    };
  };
}
