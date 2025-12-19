{ config, lib, ... }:
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
      };
    };
  };
}
