{ pkgs, lib, ... }:
{
  options = {
    palette = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      description = ''
        A base16 color scheme.
      '';
      default = { };
      visible = false;
    };
  };

  config.palette =
    let
      colorzOut = lib.strings.splitString "\n" (builtins.readFile (pkgs.runCommand "palette" {
        image = "${ ./home-manager-private }/Deathwing - Heroes of the Storm (unpacked)/materials/be94bcb77b47e00d53bc0e7fe44a48c8_1_0_art.jpg";
      } ''
        ${ pkgs.colorz }/bin/colorz -n 8 --no-preview "$image" | sed 's/ /\n/g' > $out
      ''));
    in lib.mkDefault {
      palette = {
        base00 = builtins.elemAt colorzOut 1;
        base01 = builtins.elemAt colorzOut 0;
        base02 = builtins.elemAt colorzOut 3;
        base03 = builtins.elemAt colorzOut 2;
        base04 = builtins.elemAt colorzOut 5;
        base05 = builtins.elemAt colorzOut 4;
        base06 = builtins.elemAt colorzOut 7;
        base07 = builtins.elemAt colorzOut 6;
        base08 = builtins.elemAt colorzOut 9;
        base09 = builtins.elemAt colorzOut 8;
        base0A = builtins.elemAt colorzOut 11;
        base0B = builtins.elemAt colorzOut 10;
        base0C = builtins.elemAt colorzOut 13;
        base0D = builtins.elemAt colorzOut 12;
        base0E = builtins.elemAt colorzOut 15;
        base0F = builtins.elemAt colorzOut 14;
      };
    };
}
