{ config, pkgs, lib, ... }:
let
  cfg = config.usermod.git;
in {
  options.usermod.git = {
    enable = lib.mkEnableOption "manage git config";
  };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      package = pkgs.gitFull;
      settings = {
        init.defaultBranch = "master";
        user = {
          name = "Jomar Milan";
          email = "jomarm@jomarm.com";
          signingkey = "F954C5C95AE7A312183DA76C6AC46A6F9A5618D8";
        };
        tag = {
          gpgsign = true;
          forcesignannotated = true;
        };
        sendemail = {
          smtpencryption = "ssl";
          smtpserver = "smtp.emailarray.com";
          smtpuser = "jomarm@jomarm.com";
        };
        "diff \"json\"".textconv = "${ pkgs.jq }/bin/jq .";
      };
    };
  };
}
