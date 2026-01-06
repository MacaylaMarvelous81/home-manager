{ config, pkgs, lib, ... }:
let
  cfg = config.usermod.neovim;
  neovim = pkgs.neovim.override { withNodeJs = true; };
  patched-neovim = (pkgs.symlinkJoin {
    inherit (neovim) pname version meta;
    paths = [ neovim ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/nvim \
        --prefix PATH : ${ with pkgs; lib.makeBinPath [
          # AstroNvim
          ripgrep
          # For some reason, despite withPython3, python3 is not in the PATH like Node is
          python3
          # Lua
          lua-language-server stylua selene
          # Typescript
          vtsls
          # Typst
          tinymist
          # Python
          basedpyright black isort
          # Nix
          nixd deadnix statix
          # Rust
          rust-analyzer
      ] }
    '';
  });
in {
  options.usermod.neovim = {
    enable = lib.mkEnableOption "management of user neovim settings";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ patched-neovim ];

    xdg.configFile = {
      "nvim/.luarc.json".source = ./config/.luarc.json;
      "nvim/.neoconf.json".source = ./config/.neoconf.json;
      "nvim/.stylua.toml".source = ./config/.stylua.toml;
      "nvim/init.lua".source = ./config/init.lua;
      "nvim/lua".source = ./config/lua;
      "nvim/lazy-lock.fixed.json" = {
        source = ./config/lazy-lock.fixed.json;
        onChange = ''
        install -m 0644 ${ ./config/lazy-lock.fixed.json } ${ config.xdg.configHome }/nvim/lazy-lock.json
        '';
      };
      "nvim/neovim.yml".source = ./config/neovim.yml;
      "nvim/selene.toml".source = ./config/selene.toml;
    };

    home.sessionVariables = {
      EDITOR = "${ patched-neovim }/bin/nvim";
    };

    programs.neovide = {
      enable = true;
      settings = {
        neovim-bin = "${ patched-neovim }/bin/nvim";
      };
    };

    programs.niri = lib.mkIf config.usermod.niri.enable {
      settings = with config.lib.niri.actions; {
        binds = {
          "Mod+Z".action = spawn "${ config.programs.neovide.package }/bin/neovide";
        };
      };
    };
  };
}
