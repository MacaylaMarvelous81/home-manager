{ config, pkgs, lib, wrappedModules, ... }:
let
  cfg = config.usermod.neovim;
  neovim = wrappedModules.neovim.wrap { inherit pkgs; };
  neovide = wrappedModules.neovide.wrap {
    inherit pkgs;
    settings = {
      neovim-bin = "${ neovim }/bin/nvim";

      font = {
        normal = config.stylix.fonts.monospace.name;
        size = config.stylix.fonts.sizes.terminal;
      };
    };
  };
in {
  options.usermod.neovim = {
    enable = lib.mkEnableOption "management of user neovim settings";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      neovim
      neovide
    ];

    home.sessionVariables = {
      EDITOR = "${ neovim }/bin/nvim";
    };

    programs.niri = lib.mkIf config.usermod.niri.enable {
      settings = with config.lib.niri.actions; {
        binds = {
          "Mod+Z".action = spawn "${ neovide }/bin/neovide";
        };
      };
    };
  };
}
