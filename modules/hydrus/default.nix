{ config, pkgs, lib, ... }:
let
  cfg = config.usermod.hydrus;
  hydrus-wrapped = pkgs.symlinkJoin {
    inherit (pkgs.hydrus) pname version meta;
    paths = [ pkgs.hydrus ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/hydrus-client \
        --unset WAYLAND_DISPLAY \
        --add-flag '-d=${ config.home.homeDirectory }/${ cfg.dbDir }'
    '';
  };
in {
  options.usermod.hydrus = {
    enable = lib.mkEnableOption "hydrus network configuration";
    dbDir = lib.mkOption {
      type = lib.types.str;
      description = "Location of the hydrus network database directory relative to the home directory";
      default = "Hydrus";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ hydrus-wrapped ];

    home.file = {
      # to apply this stylesheet, set the Qt stylesheet option under
      # style in the client options
      "${ cfg.dbDir }/static/qss/user.qss".source = lib.mkIf config.stylix.enable (config.lib.stylix.colors {
        template = ./user.qss.mustache;
        extension = ".qss";
      });
    };
  };
}
