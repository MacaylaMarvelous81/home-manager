{
  description = "Home Manager configuration of jomarm";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    {
      homeConfigurations = builtins.listToAttrs(builtins.map(system:
        let
          pkgs = import nixpkgs { inherit system; };
        in {
          name = "jomarm-${system}";
          value = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;

            # Specify your home configuration modules here, for example,
            # the path to your home.nix.
            modules = [ ./home.nix ];

            # Optionally use extraSpecialArgs
            # to pass through arguments to home.nix
            extraSpecialArgs = {
              homePath = if builtins.match ".*darwin.*" system != null then "/Users/jomarm" else "/home/jomarm";
            };
          };
        }
      ) ["x86_64-linux" "x86_64-darwin"]);
    };
}
