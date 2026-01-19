{ config, pkgs, lib, macaylamarvelous81-pkgs, ... }:
let
  cfg = config.usermod.offlineimap;
in {
  options.usermod.offlineimap = {
    enable = lib.mkEnableOption "management of offlineimap user config";
  };

  config = lib.mkIf cfg.enable {
    accounts.email.accounts."jomarm".offlineimap = {
      enable = true;
      postSyncHookCommand = "${ macaylamarvelous81-pkgs.jomarm-offlineimap-postsynchook }/bin/jomarm-offlineimap-postsynchook ${ config.accounts.email.maildirBasePath }/${ config.accounts.email.accounts."jomarm".maildir.path }/INBOX";
    };

    programs.offlineimap.enable = true;
  };
}
