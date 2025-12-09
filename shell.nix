let
  sources = import ./npins;
  pkgs = import sources.nixpkgs {};
in pkgs.mkShell {
  nativeBuildInputs = [
    pkgs.npins
    (import sources.home-manager { inherit pkgs; }).home-manager
  ];
  shellHook = ''
  export NIX_PATH="nixpkgs=${ sources.nixpkgs }:home-manager=${ sources.home-manager }"
  '';
}
