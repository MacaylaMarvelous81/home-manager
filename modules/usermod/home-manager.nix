{ sources }: { config, pkgs, lib, ... }:
let
  cfg = config.usermod.home-manager;
  home-manager = config.programs.home-manager.package;
  home-manager-wrapped = pkgs.symlinkJoin {
    inherit (home-manager) name meta;
    paths = [ home-manager ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/home-manager \
        --prefix NIX_PATH : nixpkgs=${ sources.nixpkgs }:home-manager=${ sources.home-manager } \
        --set-default HOME_MANAGER_CONFIG ${ cfg.configLocation }
    '';
  };
in {
  options.usermod.home-manager = {
    enable = lib.mkEnableOption "wrapped standalone home-manager tool";
    configLocation = lib.mkOption {
      type = lib.types.str;
      default = "$HOME/.config/home-manager/home.nix";
      example = "$HOME/.config/home-manager/machines/mbp20012/home.nix";
      description = "The path where the home-manager config file is.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ home-manager-wrapped ];
  };
}
