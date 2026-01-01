{ config, pkgs, lib, ... }:
let
  cfg = config.usermod.gpg;
in {
  options.usermod.gpg = {
    enable = lib.mkEnableOption "manage gpg config";
  };

  config = lib.mkIf cfg.enable {
    programs.gpg = {
      enable = true;
      publicKeys = [
        {
          source = ./keys/F954C5C95AE7A312183DA76C6AC46A6F9A5618D8.asc;
          trust = "ultimate";
        }
      ];
      scdaemonSettings.disable-ccid = true;
    };

    services.gpg-agent = {
      enable = true;
      enableBashIntegration = true;
      enableExtraSocket = true;
      enableZshIntegration = true;
      pinentry.package = if pkgs.stdenv.hostPlatform.isDarwin then pkgs.pinentry_mac else pkgs.pinentry-qt;
    };
  };
}
