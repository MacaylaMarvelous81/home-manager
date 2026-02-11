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
        languages.Nix.language_servers = [ "nixd" "!nil" ];
        lsp.tinymist.initialization_options.preview.background.enabled = true;
      };
    };

    programs.niri = lib.mkIf config.usermod.niri.enable {
      settings = with config.lib.niri.actions; {
        binds = {
          # zeditor from the PATH is used because the home-manager module's wrapped package is
          # installed directly with home.packages, and thus the derivation is not easily accessible
          # through an attribute like config.programs.zed-editor.package which contains the unwrapped
          # package instead
          "Mod+Z".action = spawn "zeditor";
        };
      };
    };
  };
}
