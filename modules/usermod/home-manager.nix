{ config, pkgs, lib, ... }:
let
  cfg = config.usermod.home-manager;
  home-manager = config.programs.home-manager.package;
  home-manager-wrapped = pkgs.symlinkJoin {
    inherit (home-manager) name meta;
    paths = [ home-manager ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/home-manager \
        --prefix NIX_PATH : nixpkgs=${ config.xdg.configHome }/home-manager/pins/nixpkgs:home-manager=${ config.xdg.configHome }/home-manager/pins/home-manager \
        --set-default HOME_MANAGER_CONFIG ${ cfg.configLocation }
    '';
  };
in {
  options.usermod.home-manager = {
    enable = lib.mkEnableOption "wrapped standalone home-manager tool";
    sources = lib.mkOption {
      description = "The version-pinned sources from a tool like niv or npins.";
    };
    configLocation = lib.mkOption {
      type = lib.types.str;
      default = "${ config.xdg.configHome }/home-manager/home.nix";
      example = "\${ config.xdg.configHome }/home-manager/machines/mbp20012/home.nix";
      description = "The path where the home-manager config file is.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ home-manager-wrapped ];

    xdg.configFile = {
      "home-manager/pins/nixpkgs".source = cfg.sources.nixpkgs;
      "home-manager/pins/home-manager".source = cfg.sources.home-manager;
    };
  };
}
