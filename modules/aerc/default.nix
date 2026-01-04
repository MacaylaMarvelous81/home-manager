{ config, pkgs, lib, ... }:
let
  cfg = config.usermod.aerc;
in {
  options.usermod.aerc = {
    enable = lib.mkEnableOption "configured aerc";
  };

  config = lib.mkIf cfg.enable {
    accounts.email.accounts."jomarm".aerc = {
      enable = true;
      extraAccounts = {
        pgp-opportunistic-encrypt = true;
        pgp-auto-sign = true;
        signature-file = "${ ./jomarm-sig }";
      };
      extraBinds = {
        view.ga = ":pipe -mb ${ config.programs.git.package } am -3<Enter>";
      };
    };

    programs.aerc = {
      enable = true;
      extraConfig = {
        general = {
          # Necessary due to a documented home-manager limitation. Safe because password command option is used instead
          # of storing the password directly in the configuration file.
          unsafe-accounts-conf = true;
        };
        filters = {
          "text/plain" = "colorize";
          "text/calendar" = "calendar";
          "message/delivery-status" = "colorize";
          "message/rfc822" = "colorize";
          "text/html" = "!html";
        };
      };
      extraBinds = builtins.readFile "${ config.programs.aerc.package }/share/aerc/binds.conf";
    };
  };
}
