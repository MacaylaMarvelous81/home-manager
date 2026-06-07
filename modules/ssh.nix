{ config, lib, ... }:
let
  cfg = config.usermod.ssh;
in
{
  options.usermod.ssh = {
    enable = lib.mkEnableOption "manage ssh user conf";
  };

  config = lib.mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings."*" = {
        UserKnownHostsFile = "~/.ssh/known_hosts";
        ControlPath = "~/.ssh/master-%r@%n:%p";
      };
    };
  };
}
