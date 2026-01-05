{ config, pkgs, lib, ... }:
let
  cfg = config.usermod.hydrus;
  hydrus = pkgs.hydrus.overrideAttrs (finalAttrs: previousAttrs: {
    version = "653";

    src = pkgs.fetchFromGitHub {
      owner = "hydrusnetwork";
      repo = "hydrus";
      tag = "v${ finalAttrs.version }";
      hash = "sha256-OH07OvN5EaEsjlUHUJMqproiVcN75yL9u7lnCjXSITo=";
    };

    postInstall = ''
      wrapProgram $out/bin/hydrus-client \
        --add-flag '-d=${ config.home.homeDirectory }/Hydrus'
    '';
  });
in {
  options.usermod.hydrus = {
    enable = lib.mkEnableOption "hydrus network configuration";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ hydrus ];

    home.file = {
      "Hydrus/static/qss/user.qss".source = lib.mkIf config.stylix.enable (config.lib.stylix.colors {
        template = ./user.qss.mustache;
        extension = ".qss";
      });
    };
  };
}
