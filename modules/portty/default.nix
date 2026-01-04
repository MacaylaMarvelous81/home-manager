{ config, pkgs, lib, ... }:
let
  cfg = config.usermod.portty;
  portty = pkgs.rustPlatform.buildRustPackage (finalAttrs: {
    pname = "portty";
    version = "0.1.0";

    src = pkgs.fetchFromGitHub {
      owner = "WERDXZ";
      repo = "portty";
      rev = "v${ finalAttrs.version }";
      hash = "sha256-7nzPTeC2e2cOrWb8Z7di5qk8pLTgptnHRT1Qg31juYA=";
    };

    cargoHash = "sha256-HLuA0512SH7vE1+hbEFJlt0Xq5G2MuX/POlwoiFOYRA=";

    postPatch = ''
      substituteInPlace misc/portty.service \
        --replace-fail /usr/lib/portty/porttyd $out/libexec/porttyd
    '';
    installPhase =
      let
        targetSubdirectory = pkgs.rustPlatform.cargoInstallHook.targetSubdirectory;
      in ''
        runHook preInstall

        releaseDir=target/${ targetSubdirectory }/$cargoBuildType

        install -Dm755 $releaseDir/portty $out/bin/portty
        install -Dm755 $releaseDir/porttyd $out/libexec/porttyd
        install -Dm644 misc/tty.portal $out/share/xdg-desktop-portal/portals/tty.portal
        install -Dm644 misc/portty.service $out/lib/systemd/user/portty.service

        runHook postInstall
      '';
  });
in {
  options.usermod.portty = {
    enable = lib.mkEnableOption "installation of portty portal backend";
    termProgram = lib.mkOption {
      type = lib.types.str;
      default = "${ config.programs.kitty.package }/bin/kitty -e";
      description = "The command to use for the terminal emulator for portty to open";
    };
  };

  config = lib.mkIf cfg.enable {
    # the portty daemon is responsible for acquiring the D-Bus name, not
    # the systemd unit, so it is not automatically started by xdg-desktop-portal
    systemd.user.services.portty = {
      Unit = {
        Description = "Portty - XDG Desktop Portal for TTY";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${ portty }/libexec/porttyd";
        Restart = "on-failure";
        RestartSec = 5;
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    xdg.portal = {
      config.niri = lib.mkIf config.usermod.niri.enable {
        "org.freedesktop.impl.portal.FileChooser" = [ "tty" ];
      };
      extraPortals = [ portty ];
    };

    xdg.configFile = {
      "portty/config.toml".text = ''
        exec = "${ cfg.termProgram } ${ ./shell-wrapper.sh }"
      '';
    };
  };
}
