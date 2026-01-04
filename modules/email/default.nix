{ config, pkgs, lib, ... }:
let
  cfg = config.usermod.email;
in {
  options.usermod.email = {
    enable = lib.mkEnableOption "email config";
  };

  config = lib.mkIf cfg.enable {
    accounts.email.certificatesFile = "${ pkgs.cacert }/etc/ssl/certs/ca-bundle.crt";
    accounts.email.accounts = {
      "jomarm" = {
        address = "jomarm@jomarm.com";
        gpg = {
          encryptByDefault = true;
          key = "6AC46A6F9A5618D8";
          signByDefault = true;
        };
        imap = {
          host = "imap.emailarray.com";
          port = 993;
          tls.enable = true;
        };
        smtp = {
          host = "smtp.emailarray.com";
          port = 465;
          tls.enable = true;
        };
        userName = "jomarm@jomarm.com";
        passwordCommand = "cat ${ config.sops.secrets."email/accounts/jomarm".path }";
        primary = true;
        realName = "Jomar Milan";
      };
    };
  };
}
