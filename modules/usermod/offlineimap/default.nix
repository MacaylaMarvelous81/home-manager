{ config, pkgs, lib, ... }:
let
  cfg = config.usermod.offlineimap;
  jomarm-offlineimap-postsynchook = pkgs.rustPlatform.buildRustPackage {
    pname = "jomarm-offlineimap-postsynchook";
    version = "0.1.0";

    buildInputs = lib.optionals pkgs.stdenv.hostPlatform.isLinux [ pkgs.alsa-lib ];
    nativeBuildInputs = lib.optionals pkgs.stdenv.hostPlatform.isLinux [ pkgs.pkg-config ];

    src = pkgs.fetchFromGitHub {
      owner = "MacaylaMarvelous81";
      repo = "offlineimap-postsynchook";
      rev = "8b13829b034c54207a36dff32b73b08656a685cc";
      hash = "sha256-VYmGu2ZSmjeR88J+2CZ1L6fu+KLIyuN/omYzUg+Yyyo=";
    };

    cargoHash = "sha256-xyGHUUeaF7V6IEB7UHZf0eqzZrHUcuEeFiEyMB0vTJ4=";
  };
in {
  options.usermod.offlineimap = {
    enable = lib.mkEnableOption "management of offlineimap user config";
  };

  config = lib.mkIf cfg.enable {
    accounts.email.accounts."jomarm".offlineimap = {
      enable = true;
      postSyncHookCommand = "${ jomarm-offlineimap-postsynchook }/bin/jomarm-offlineimap-postsynchook ${ config.accounts.email.maildirBasePath }/${ config.accounts.email.accounts."jomarm".maildir.path }/INBOX";
    };

    programs.offlineimap.enable = true;
  };
}
