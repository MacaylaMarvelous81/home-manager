{ pkgs, ... }:
let
  jomarm-offlineimap-postsynchook = pkgs.rustPlatform.buildRustPackage {
    pname = "jomarm-offlineimap-postsynchook";
    version = "0.1.0";

    src = pkgs.fetchFromGitHub {
      owner = "MacaylaMarvelous81";
      repo = "offlineimap-postsynchook";
      rev = "60e36f34e8a1888fe4e54173527e74ed4e5f1300";
      hash = "sha256-ptCnyKM++r/SkguGT3urMWN2AeAl4wb+LgwJ3a/CbWg=";
    };

    cargoHash = "sha256-xyGHUUeaF7V6IEB7UHZf0eqzZrHUcuEeFiEyMB0vTJ4=";
  };
in {
  accounts.email.accounts."jomarm".offlineimap = {
    enable = pkgs.stdenv.hostPlatform.isLinux;
    postSyncHookCommand = "${ jomarm-offlineimap-postsynchook }/bin/jomarm-offlineimap-postsynchook";
  };

  programs.offlineimap.enable = pkgs.stdenv.hostPlatform.isLinux;
}
