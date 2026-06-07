{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.usermod.neovim;
in
{
  options.usermod.neovim = {
    enable = lib.mkEnableOption "neovim module";
    neovide = lib.mkEnableOption "neovide";
  };

  config = lib.mkIf cfg.enable {
    programs.lazyvim = {
      enable = true;
      extras = {
        lang.nix = {
          enable = true;
          config = ''
            return {
              "neovim/nvim-lspconfig",
              opts = {
                servers = {
                  nixd = {},
                },
              },
            }
          '';
        };
      };
      extraPackages = with pkgs; [
        nixd
        nixfmt
        statix
      ];
    };

    programs.neovide = lib.mkIf cfg.neovide {
      enable = true;
    };

    programs.niri = lib.mkIf (cfg.neovide && config.usermod.niri.enable) {
      settings = with config.lib.niri.actions; {
        binds = {
          "Mod+Z".action = spawn "${config.programs.neovide.package}/bin/neovide";
        };
      };
    };
  };
}
