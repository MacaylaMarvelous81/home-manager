{ config, pkgs, lib, wlib, ... }:
{
  imports = [ wlib.modules.default ];

  options = {
    neovim-bin = lib.mkOption {
      type = lib.types.str;
      default = "${ pkgs.neovim }/bin/nvim";
      description = "Neovim binary to invoke headlessly";
    };
  };

  config = {
    package = lib.mkDefault pkgs.neovide;
    flags = {
      "--neovim-bin" = config.neovim-bin;
    };
  };
}
