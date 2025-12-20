{ config, pkgs, lib, ... }:
let
  cfg = config.usermod.stylix;
  stylix = builtins.fetchTarball "https://github.com/nix-community/stylix/archive/e6829552d4bb659ebab00f08c61d8c62754763f3.tar.gz";
in {
  imports = [ (import stylix).homeModules.stylix ];

  options.usermod.stylix = {
    enable = lib.mkEnableOption "stylix usage";
  };

  config = lib.mkIf cfg.enable {
    stylix.enable = true;
  };
}
