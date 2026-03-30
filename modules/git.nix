{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.usermod.git;
in
{
  options.usermod.git = {
    enable = lib.mkEnableOption "manage git config";
  };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      package = pkgs.gitFull;
      signing = {
        format = "openpgp";
        key = "F954C5C95AE7A312183DA76C6AC46A6F9A5618D8";
        signByDefault = true;
      };
      settings = {
        init.defaultBranch = "master";
        user = {
          name = "Jomar Milan";
          email = "jomarm@jomarm.com";
        };
        sendemail = {
          smtpencryption = "ssl";
          smtpserver = "smtp.emailarray.com";
          smtpuser = "jomarm@jomarm.com";
        };
        "diff \"json\"".textconv = "${pkgs.jq}/bin/jq .";
      };
    };
  };
}
