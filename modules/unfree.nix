{ config, lib, ... }:
let
  cfg = config.usermod.unfree;
in {
  options.usermod.unfree = {
    # maybe take a list of lambdas instead for more flexible behavior?
    pkgnames = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Names of unfree packages to allow";
    };
  };

  config = {
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) cfg.pkgnames;
  };
}
