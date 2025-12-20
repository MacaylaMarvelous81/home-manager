{ config, pkgs, lib, ... }:
let
  cfg = config.usermod.noctalia-shell;
  noctalia-shell = builtins.fetchTarball "https://github.com/noctalia-dev/noctalia-shell/archive/refs/tags/v3.7.1.tar.gz";
in {
  imports = [
    "${ noctalia-shell }/nix/home-module.nix"
  ];

  options.usermod.noctalia-shell = {
    enable = lib.mkEnableOption "management of noctalia-shell via external module";
  };

  config = lib.mkIf cfg.enable {
    programs.noctalia-shell = {
      enable = true;
      systemd.enable = true;
      package = pkgs.callPackage "${ noctalia-shell }/nix/package.nix" {};
    };
  };
}
