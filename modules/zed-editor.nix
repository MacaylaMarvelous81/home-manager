{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.usermod.zed-editor;
in
{
  options.usermod.zed-editor = {
    enable = lib.mkEnableOption "Zed editor options";
  };

  config = lib.mkIf cfg.enable {
    programs.zed-editor = {
      enable = true;
      extensions = [
        "nix"
        "typst"
      ];
      mutableUserSettings = false;
      userSettings = {
        disable_ai = true;
        telemetry = {
          diagnostics = false;
          metrics = false;
        };
        lsp.nixd.binary.path = "${pkgs.nixd}/bin/nixd";
        languages.Nix.language_servers = [
          "nixd"
          "!nil"
        ];
        languages.Nix.formatter.external.command = "${pkgs.nixfmt}/bin/nixfmt";
        # lsp.tinymist.binary.path = "${pkgs.tinymist}/bin/tinymist";
        languages.Typst.enable_language_server = false;
      };
    };

    programs.niri = lib.mkIf config.usermod.niri.enable {
      settings = with config.lib.niri.actions; {
        binds = {
          "Mod+Z".action = spawn "${config.programs.zed-editor.package}/bin/zeditor";
        };
      };
    };
  };
}
