{ config, lib, ... }:
let
  cfg = config.usermod.firefox;
in
{
  options.usermod.firefox = {
    enable = lib.mkEnableOption "managment of firefox user config";
  };

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      profiles = {
        default = {
          settings = lib.mkMerge [
            (lib.mkIf config.xdg.portal.enable {
              # 0 = never, 1 = always, 2 = automatic
              "widget.use-xdg-desktop-portal.file-picker" = 1;
            })
          ];
        };
      };
      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        DisablePocket = true;
        DisableFirefoxAccounts = true;
        DisableAccounts = true;
        DisableFirefoxScreenshots = true;
        FirefoxSuggest = {
          WebSuggestions = false;
          SponsoredSuggestions = false;
          ImproveSuggest = false;
          Locked = true;
        };
        GenerativeAI = {
          Enabled = false;
          Chatbot = false;
          LinkPreviews = false;
          TabGroups = false;
          Locked = true;
        };
        FirefoxHome = {
          Search = false;
          TopSites = false;
          SponsoredTopSites = false;
          Highlights = false;
          Pocket = false;
          Stories = false;
          SponsoredPocket = false;
          SponsoredStories = false;
          Snippets = false;
          Locked = true;
        };
        OverrideFirstRunPage = "";
        OverridePostUpdatePage = "";
        DontCheckDefaultBrowser = true;
        DisplayBookmarksToolbar = "newtab";
        DisplayMenuBar = "default-off";

        ExtensionSettings = {
          "*".installation_mode = "blocked";

          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
          };
        };
      };
    };

    programs.niri = lib.mkIf config.usermod.niri.enable {
      settings = with config.lib.niri.actions; {
        binds = {
          "Mod+B".action = spawn "${config.programs.firefox.finalPackage}/bin/firefox";
        };
      };
    };
  };
}
