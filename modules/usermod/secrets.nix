{ config, lib, ... }:
let
  cfg = config.usermod.secrets;
in {
  options.usermod.secrets = {
    enable = lib.mkEnableOption "management of secrets via sops-nix";
  };

  config = lib.mkIf cfg.enable {
    # Using sops-nix for secrets management avoids having the secrets exposed
    # in the nix store
    sops = {
      defaultSopsFile = ../../home-manager-private/secrets.yaml;

      gnupg = {
        home = "~/.gnupg";
        sshKeyPaths = [];
      };

      secrets = {
        "email/accounts/jomarm" = {};
      };
    };
  };
}
