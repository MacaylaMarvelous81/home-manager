{ config, pkgs, lib, ... }:
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
    home.packages = with pkgs; [ atool ];

    home.file = {
      ".atoolrc".text = ''
        path_tar ${ pkgs.gnutar }/bin/tar
        path_zip ${ pkgs.zip }/bin/zip
        path_unzip ${ pkgs.unzip }/bin/unzip
        path_gzip ${ pkgs.gzip }/bin/gzip
        path_bzip2 ${ pkgs.bzip2 }/bin/bzip2
        path_lzma ${ pkgs.xz }/bin/lzma
        path_rar ${ pkgs.rar }/bin/rar
        path_unrar ${ pkgs.unrar }/bin/unrar
        path_7z ${ pkgs.p7zip }/bin/7z
      '';
    };
  };
}
