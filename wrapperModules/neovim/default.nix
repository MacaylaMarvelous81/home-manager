{ pkgs, lib, wlib, ... }:
{
  imports = [ wlib.modules.default ];

  config = {
    package = lib.mkDefault pkgs.neovim;
    extraPackages = with pkgs; [
      # AstroNvim
      ripgrep
      python3
      # Lua
      lua-language-server stylua selene
      # TypeScript
      vtsls
      # Typst
      tinymist
      # Python
      black isort
      # Nix
      nixd deadnix statix
      # Rust
      rust-analyzer
    ]
      # clang_20 currently fails to build on darwin, which is required for basedpyright
      ++ lib.optionals (!pkgs.stdenv.hostPlatform.isDarwin) [ basedpyright ];
    env = {
      XDG_CONFIG_HOME = ./config;
    };
  };
}
