{ config, lib, ... }:
let
  cfg = config.usermod.nixvim;
in
{
  options.usermod.nixvim = {
    enable = lib.mkEnableOption "nixvim module";
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      enable = true;
      imports = [ ../nixvim/config ];
    };
  };
}
