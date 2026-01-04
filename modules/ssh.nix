{ config, lib, ... }:
let
  cfg = config.usermod.ssh;
in {
  options.usermod.ssh = {
    enable = lib.mkEnableOption "manage ssh user conf";
  };

  config = lib.mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        "*" = {
          userKnownHostsFile = "~/.ssh/known_hosts";
          controlPath = "~/.ssh/master-%r@%n:%p";
        };
      };
    };
  };
}
