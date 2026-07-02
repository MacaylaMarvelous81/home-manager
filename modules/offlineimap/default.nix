{
  config,
  pkgs,
  lib,
  macaylamarvelous81-pkgs,
  ...
}:
let
  cfg = config.usermod.offlineimap;
in
{
  options.usermod.offlineimap = {
    enable = lib.mkEnableOption "management of offlineimap user config";
  };

  config = lib.mkIf cfg.enable {
    accounts.email.accounts."jomarm".offlineimap = {
      enable = true;
      postSyncHookCommand = "${macaylamarvelous81-pkgs.jomarm-offlineimap-postsynchook}/bin/jomarm-offlineimap-postsynchook ${config.accounts.email.maildirBasePath}/${
        config.accounts.email.accounts."jomarm".maildir.path
      }/INBOX";
    };

    programs.offlineimap.enable = true;

    systemd.user.services.offlineimap = {
      Unit = {
        Description = "Offlineimap: a software to dispose your mailbox(es) as a local Maildir(s)";
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${config.programs.offlineimap.package}/bin/offlineimap -u syslog -o -1";
        TimeoutStartSec = "120sec";
      };
    };
    systemd.user.timers.offlineimap = {
      Unit = {
        Description = "offlineimap timer";
      };
      Timer = {
        Unit = "offlineimap.service";
        OnCalendar = "*:0/3";
        Persistent = "true";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
}
