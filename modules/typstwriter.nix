{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.usermod.typstwriter;
in
{
  options.usermod.typstwriter = {
    enable = lib.mkEnableOption "Typstwriter application";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ typstwriter ];

    home.file = {
      ".typstwriter.ini".text = ''
        [Compiler]
        name = ${pkgs.typst}/bin/typst
        mode = live
      '';
    };
  };
}
