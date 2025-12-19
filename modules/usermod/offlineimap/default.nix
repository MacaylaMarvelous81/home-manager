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
      rev = "60e36f34e8a1888fe4e54173527e74ed4e5f1300";
      hash = "sha256-ptCnyKM++r/SkguGT3urMWN2AeAl4wb+LgwJ3a/CbWg=";
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
      postSyncHookCommand = "${ jomarm-offlineimap-postsynchook }/bin/jomarm-offlineimap-postsynchook";
    };

    programs.offlineimap.enable = true;
  };
}
