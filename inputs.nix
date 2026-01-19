{ sources }: { pkgs, lib, ... }:
let
  niri-flake = (import sources.flake-compat) { src = sources.niri-flake; };
in {
  _module.args =
    let
      wrappers = import sources.wrappers {
        inherit pkgs;
        nixpkgs = sources.nixpkgs;
      };
    in {
      wrappers = import ./wrappers.nix {
        inherit pkgs lib;
        wlib = wrappers.lib;
      };
    };

  imports = [
    niri-flake.outputs.homeModules.niri
    niri-flake.outputs.homeModules.stylix
    "${ sources.noctalia-shell }/nix/home-module.nix"
    (import sources.stylix).homeModules.stylix
    "${ sources.sops-nix }/modules/home-manager/sops.nix"
  ];
}
