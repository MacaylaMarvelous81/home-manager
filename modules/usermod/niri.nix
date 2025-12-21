{ config, pkgs, lib, ... }:
let
  cfg = config.usermod.niri;
in {
  options.usermod.niri = {
    enable = lib.mkEnableOption "management of niri options using niri-flake";
  };

  config = lib.mkIf cfg.enable {
    programs.niri = {
      enable = true;
      package = pkgs.niri;
      settings = with config.lib.niri.actions; {
        binds = {
          "Mod+Left".action = focus-column-left;
          "Mod+Right".action = focus-column-right;
          "Mod+Down".action = focus-window-or-workspace-down;
          "Mod+Up".action = focus-window-or-workspace-up;

          "Mod+Ctrl+Left".action = move-column-left;
          "Mod+Ctrl+Right".action = move-column-right;
          "Mod+Ctrl+Down".action = move-window-down-or-to-workspace-down;
          "Mod+Ctrl+Up".action = move-window-up-or-to-workspace-up;

          "Mod+Shift+Left".action = focus-monitor-left;
          "Mod+Shift+Right".action = focus-monitor-right;
          "Mod+Shift+Down".action = focus-monitor-down;
          "Mod+Shift+Up".action = focus-monitor-up;

          "Mod+Shift+Ctrl+Left".action = move-column-to-monitor-left;
          "Mod+Shift+Ctrl+Right".action = move-column-to-monitor-right;
          "Mod+Shift+Ctrl+Down".action = move-window-to-monitor-down;
          "Mod+Shift+Ctrl+Up".action = move-window-to-monitor-up;

          "Mod+Alt+Left".action = consume-or-expel-window-left;
          "Mod+Alt+Right".action = consume-or-expel-window-right;

          "Mod+F".action = maximize-column;
          "Mod+Shift+F".action = fullscreen-window;

          "Mod+D".action = toggle-window-floating;
          "Mod+Shift+D".action = switch-focus-between-floating-and-tiling;

          "Mod+C".action = toggle-column-tabbed-display;

          "Mod+Home".action = focus-column-first;
          "Mod+End".action = focus-column-last;

          "Mod+Ctrl+Home".action = move-column-to-first;
          "Mod+Ctrl+End".action = move-column-to-last;

          "Mod+Ctrl+Alt+Delete".action = quit;

          "Mod+R".action = switch-preset-column-width;

          "Mod+V".action = toggle-overview;

          "Mod+Q".action = close-window;

          "Mod+Escape".action = toggle-keyboard-shortcuts-inhibit;
          "Mod+Escape".allow-inhibiting = false;

          "Mod+T".action = spawn "${ pkgs.alacritty }/bin/alacritty";
          "Mod+E".action = spawn "${ pkgs.nautilus }/bin/nautilus" "--new-window";
          "Mod+Z".action = spawn "${ config.programs.neovide.package }/bin/neovide";

          "Mod+Space".action = spawn "${ config.programs.noctalia-shell.package }/bin/noctalia-shell" "ipc" "call" "launcher" "toggle";
          "Mod+L".action = spawn "${ config.programs.noctalia-shell.package }/bin/noctalia-shell" "ipc" "call" "lockScreen" "lock";

          "Mod+Delete".action = spawn "${ config.programs.noctalia-shell.package }/bin/noctalia-shell" "ipc" "call" "sessionMenu" "toggle";

          "Print".action.screenshot = {
            show-pointer = false;
          };

          "Shift+Print".action.screenshot-screen = {
            show-pointer = false;
          };

          "Alt+Print".action.screenshot-window = {};

          "XF86AudioRaiseVolume" = {
            allow-when-locked = true;
            action = spawn "${ pkgs.wireplumber }/bin/wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.01+";
          };

          "XF86AudioLowerVolume" = {
            allow-when-locked = true;
            action = spawn "${ pkgs.wireplumber }/bin/wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.01-";
          };

          "Shift+XF86AudioRaiseVolume" = {
            allow-when-locked = true;
            action = spawn "${ pkgs.wireplumber }/bin/wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+";
          };

          "Shift+XF86AudioLowerVolume" = {
            allow-when-locked = true;
            action = spawn "${ pkgs.wireplumber }/bin/wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-";
          };

          "XF86AudioMute" = {
            allow-when-locked = true;
            action = spawn "${ pkgs.wireplumber }/bin/wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle";
          };

          "XF86AudioMicMute" = {
            allow-when-locked = true;
            action = spawn "${ pkgs.wireplumber }/bin/wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle";
          };

          "XF86MonBrightnessUp" = {
            allow-when-locked = true;
            action = spawn "${ pkgs.brightnessctl }/bin/brightnessctl" "--class=backlight" "set" "1%+";
          };

          "XF86MonBrightnessDown" = {
            allow-when-locked = true;
            action = spawn "${ pkgs.brightnessctl }/bin/brightnessctl" "--class=backlight" "set" "1%-";
          };

          "Shift+XF86MonBrightnessUp" = {
            allow-when-locked = true;
            action = spawn "${ pkgs.brightnessctl }/bin/brightnessctl" "--class=backlight" "set" "10%+";
          };

          "Shift+XF86MonBrightnessDown" = {
            allow-when-locked = true;
            action = spawn "${ pkgs.brightnessctl }/bin/brightnessctl" "--class=backlight" "set" "10%-";
          };
        };

        input = {
          touch = {
            enable = true;
            map-to-output = "eDP-1";
          };

          mouse = {
            enable = true;

            natural-scroll = false;
            accel-speed = 0.0;
            accel-profile = "adaptive";
            middle-emulation = false;

            scroll-factor = 0.6;
          };

          focus-follows-mouse.enable = true;
        };

        switch-events = {
          lid-close.action = spawn "${ config.programs.noctalia-shell.package }/bin/noctalia-shell" "ipc" "call" "lockScreen" "lock";
        };

        window-rules = [
          {
            geometry-corner-radius = {
              top-left = 5.0;
              top-right = 5.0;
              bottom-left = 5.0;
              bottom-right = 5.0;
            };
            clip-to-geometry = true;
          }
        ];

        debug = {
          honor-xdg-activation-with-invalid-serial = true;
        };

        spawn-at-startup = [
          { argv = [ "${ pkgs.linux-wallpaperengine }/bin/linux-wallpaperengine" "--silent" "--screen-root" "eDP-1" "--bg" "${ ../../home-manager-private }/Deathwing - Heroes of the Storm (unpacked)" ]; }
        ];

        layer-rules = [
          {
            matches = [ { namespace = "^noctalia-overview*"; }];
            place-within-backdrop = true;
          }
        ];

        xwayland-satellite.path = "${ pkgs.xwayland-satellite }/bin/xwayland-satellite";
      };
    };
  };
}
