{ config, pkgs, lib, ... }:
let
  neovim = pkgs.neovim.override { withNodeJs = true; };
  patched-neovim = (pkgs.symlinkJoin {
    inherit (neovim) pname version meta;
    paths = [ neovim ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/nvim \
        --prefix PATH : ${ lib.makeBinPath [ pkgs.nixd pkgs.deadnix pkgs.statix pkgs.rust-analyzer ] }
    '';
  });
in {
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
    DIFFPROG = "${ patched-neovim }/bin/nvim -d";
  };

  programs.neovide = {
    enable = true;
    settings = {
      neovim-bin = "${ patched-neovim }/bin/nvim";
    };
  };
}
