{ config, pkgs, lib, ... }:
let
  cfg = config.usermod.stylix;
  # new-dragon-scimitair-cursor = pkgs.stdenvNoCC.mkDerivation {
  #   pname = "new-dragon-scimitair-cursor";
  #   version = "0-unstable-2009-11-08";
  #
  #   # New Dragon Scimitair Cursors on rw-designer.com
  #   # Teddy, CC by (https://www.rw-designer.com/cursor-set/dragon-scimitaires)
  #   src = pkgs.fetchzip {
  #     url = "https://www.rw-designer.com/cursor-downloadset/dragon-scimitaires.zip";
  #     stripRoot = false;
  #     hash = "sha256-e2d2zSzWcjGyylEMJGiUOzEsMIv8cCwMAcwqKRCeF9k=";
  #   };
  #
  #   nativeBuildInputs = [ pkgs.win2xcur ];
  #
  #   buildPhase = ''
  #     mkdir output cursors
  #     win2xcur *.cur -o output
  #
  #     mv 'output/new dragon scimitair' cursors/default
  #     ln -s default cursors/left_ptr
  #     ln -s default cursors/arrow
  #     mv 'output/new dragon scimitair link' cursors/pointer
  #     ln -s pointer cursors/hand2
  #     mv 'output/new dragon scimitair busy' cursors/wait
  #     mv 'output/new dragon scimitair busy in background' cursors/progress
  #     mv 'output/new dragon scimitair help select' cursors/help
  #     ln -s help cursors/question_arrow
  #     mv 'output/new dragon scimitair text' cursors/text
  #     ln -s text cursors/xterm
  #     mv 'output/new dragon scimitair penleft' cursors/pencil
  #     mv 'output/new dragon scimitair precision select' cursors/cross
  #     ln -s cross cursors/crosshair
  #     ln -s cross cursors/tcross
  #     mv 'output/new dragon scimitair unavailable' cursors/not-allowed
  #     mv 'output/new dragon scimitair vertical' cursors/ns-resize
  #     ln -s ns-resize cursors/n-resize
  #     ln -s ns-resize cursors/s-resize
  #     ln -s ns-resize cursors/v_double_arrow
  #     ln -s ns-resize cursors/sb_v_double_arrow
  #     mv 'output/new dragon scimitair horizontal' cursors/ew-resize
  #     ln -s ew-resize cursors/e-resize
  #     ln -s ew-resize cursors/w-resize
  #     ln -s ew-resize cursors/h_double_arrow
  #     ln -s ew-resize cursors/sb_h_double_arrow
  #     ln -s ew-resize cursors/left_side
  #     ln -s ew-resize cursors/right_side
  #     mv 'output/new dragon scimitair resize1' cursors/nw-resize
  #     ln -s nw-resize cursors/top_left_corner
  #     ln -s nw-resize cursors/bottom_right_corner
  #     mv 'output/new dragon scimitair resize2' cursors/ne-resize
  #     ln -s ne-resize cursors/top_right_corner
  #     ln -s ne-resize cursors/bottom_left_corner
  #     mv 'output/new dragon scimitair move' cursors/move
  #     ln -s move cursors/nesw-resize
  #     ln -s move cursors/grab
  #     ln -s move cursors/grabbing
  #     ln -s move cursors/fleur
  #     # ln -s 'new dragon scimitair alternate' ...
  #   '';
  #
  #   installPhase = ''
  #     mkdir -p "$out/share/icons/new dragon scimitair"
  #     cp -r cursors "$out/share/icons/new dragon scimitair/cursors"
  #
  #     cat > "$out/share/icons/new dragon scimitair/index.theme" <<EOF
  #     [Icon theme]
  #     Name=new dragon scimitair
  #     EOF
  #   '';
  # };
in {
  options.usermod.stylix = {
    enable = lib.mkEnableOption "stylix usage";
  };

  config = lib.mkIf cfg.enable {
    fonts.fontconfig.enable = true;

    stylix = {
      enable = true;

      image = "${ ../home-manager-private }/Deathwing - Heroes of the Storm (unpacked)/materials/be94bcb77b47e00d53bc0e7fe44a48c8_1_0_art.jpg";
      polarity = "dark";

      cursor = {
        package = pkgs.vanilla-dmz;
        name = "Vanilla-DMZ";
        size = 24;
      };

      icons = {
        enable = true;
        package = pkgs.papirus-icon-theme;
        light = "Papirus-Light";
        dark = "Papirus-Dark";
      };

      fonts = {
        sansSerif = {
          # package = pkgs.lato;
          # name = "Lato";
          package = pkgs.cantarell-fonts;
          name = "Cantarell";
        };
        monospace = {
          package = pkgs.nerd-fonts.fira-code;
          name = "FiraCode Nerd Font";
        };
      };

      opacity.terminal = 0.8;

      targets.firefox.profileNames = [ "default" ];
      targets.qt.standardDialogs = if config.xdg.portal.enable then "xdgdesktopportal" else "default";
    };
  };
}
