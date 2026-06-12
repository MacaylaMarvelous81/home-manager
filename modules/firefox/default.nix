{
  config,
  pkgs,
  lib,
  ...
}:
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
      # new default value for state version 26.05
      configPath = "${config.xdg.configHome}/mozilla/firefox";
      profiles = {
        default = {
          search = {
            force = true;
            default = "searxng";
            engines = {
              nix-packages = {
                name = "Nix Packages";
                urls = [
                  {
                    template = "https://search.nixos.org/packages";
                    params = [
                      {
                        name = "type";
                        value = "packages";
                      }
                      {
                        name = "channel";
                        value = "unstable";
                      }
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@np" ];
              };
              nixos-wiki = {
                name = "NixOS Wiki";
                urls = [ { template = "https://wiki.nixos.org/w/index.php?search={searchTerms}"; } ];
                iconMapObj."16" = "https://wiki.nixos.org/favicon.ico";
                definedAliases = [ "@nw" ];
              };
              mojeek = {
                name = "Mojeek";
                urls = [ { template = "https://www.mojeek.com/search?q={searchTerms}"; } ];
                iconMapObj."16" = "https://www.mojeek.com/favicon.png";
                definedAliases = [ "@mojeek" ];
              };
              searxng = {
                name = "SearXNG";
                description = "SearXNG is a metasearch engine that respects your privacy.";
                urls = [
                  { template = "https://searx.tiekoetter.com/search?q={searchTerms}"; }
                  {
                    template = "https://searx.tiekoetter.com/autocompleter?q={searchTerms}";
                    type = "application/x-suggestions+json";
                  }
                ];
                iconMapObj."16" = "https://searx.tiekoetter.com/static/themes/simple/img/favicon.png";
                definedAliases = [ "@searxng" ];
              };
            };
          };
          settings = lib.mkMerge [
            (lib.mkIf config.xdg.portal.enable {
              # 0 = never, 1 = always, 2 = automatic
              "widget.use-xdg-desktop-portal.file-picker" = 1;
            })
            {
              "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            }
          ];
          userContent = ''
            @import "${./.}/clocktower.css"
          '';
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
          "WebToEpub@Baka-tsuki.org" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/webtoepub-for-baka-tsuki/latest.xpi";
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
