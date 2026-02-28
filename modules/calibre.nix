{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.usermod.calibre;
in
{
  options.usermod.calibre = {
    enable = lib.mkEnableOption "calibre program";
  };

  config = lib.mkIf cfg.enable {
    programs.calibre = {
      enable = true;
      package = pkgs.calibre.overrideAttrs (prevAttrs: {
        # Patch:
        # https://github.com/NixOS/nixpkgs/commit/3428d5442b9b5c3772c496cbbaf8ba52d86ef667
        # Context: https://github.com/NixOS/nixpkgs/issues/493843 (build failure)
        installPhase = ''
          export QMAKE="${pkgs.qt6.qtbase}/bin/qmake"
        ''
        + prevAttrs.installPhase;
      });
    };
  };
}
