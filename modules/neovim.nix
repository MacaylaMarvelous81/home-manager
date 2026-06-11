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
      plugins = {
        live-share = ''
          return {
            "azratul/live-share.nvim",
            config = function()
              require("live-share.provider").register("loopback", {
                command = function(_, port, service_url)
                  return string.format(
                    [[printf 'tcp://127.0.0.1:%d\n' > %s; sleep infinity]],
                    port, service_url)
                end,
                pattern = "tcp://[%w._-]+:%d+",
              })
              require("live-share.provider").register("raspberrypi", {
                command = function(cfg, port_internal, service_url)
                  return string.format(
                    "ssh -R 0.0.0.0:%d:localhost:%d raspberrypi " .. "'echo tcp://24.130.29.83:%d; sleep infinity' > %s 2>/dev/null",
                    cfg.port, port_internal, cfg.port, service_url)
                end,
                pattern = "tcp://[%w.+=]+:%d+",
              })
              require("live-share").setup({
                username = "jomarm",
                service = "raspberrypi",
                port = 8443,
                openssl_lib = "${pkgs.openssl.out}/lib/libcrypto.so.3",
              })
            end,
          }
        '';
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
