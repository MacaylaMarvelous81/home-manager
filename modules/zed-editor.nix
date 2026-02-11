{ config, pkgs, lib, ... }:
let
  cfg = config.usermod.zed-editor;
in {
  options.usermod.zed-editor = {
    enable = lib.mkEnableOption "Zed editor options";
  };

  config = lib.mkIf cfg.enable {
    programs.zed-editor = {
      enable = true;
      # This wrapper then gets wrapped by the home-manager module. This wrapper exists to
      # wrap the MacOS application, since the home-manager module's wrapper only wraps the
      # zeditor program.
      package = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin (pkgs.symlinkJoin {
        name = "${ lib.getName pkgs.zed-editor }-wrapped-${ lib.getVersion pkgs.zed-editor }";
        paths = [ pkgs.zed-editor ];
        preferLocalBuild = true;
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/Applications/Zed.app/Contents/MacOS/zed \
            --suffix PATH : ${ lib.makeBinPath config.programs.zed-editor.extraPackages }
        '';
      });
      extensions = [ "nix" "typst" ];
      extraPackages = with pkgs; [ nixd tinymist ];
      userSettings = {
        disable_ai = true;
        telemetry = {
          diagnostics = false;
          metrics = false;
        };
        icon_theme = {
          mode = "system";
          light = "Zed (Default)";
          dark = "Zed (Default)";
        };
        theme = {
          mode = "system";
          light = "One Light";
          dark = "One Dark";
        };
        languages.Nix.language_servers = [ "nixd" "!nil" ];
        lsp.tinymist.initialization_options.preview.background.enabled = true;
      };
    };
  };
}
