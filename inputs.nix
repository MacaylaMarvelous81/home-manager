{ sources }: { ... }:
let
  niri-flake = (import sources.flake-compat) { src = sources.niri-flake; };
in {
  imports = [
    niri-flake.outputs.homeModules.niri
    niri-flake.outputs.homeModules.stylix
    "${ sources.noctalia-shell }/nix/home-module.nix"
    (import sources.stylix).homeModules.stylix
    "${ sources.sops-nix }/modules/home-manager/sops.nix"
  ];
}
