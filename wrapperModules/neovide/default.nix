{ config, pkgs, lib, wlib, ... }:
let
  tomlFmt = pkgs.formats.toml {};
in
{
  imports = [ wlib.modules.default ];

  options = {
    settings = lib.mkOption {
      type = tomlFmt.type;
      default = {};
      description = ''
        Configuration of neovide via config file.
        See <https://neovide.dev/config-file.html>
      '';
    };
  };

  config = {
    package = lib.mkDefault pkgs.neovide;
    env = {
      NEOVIDE_CONFIG = tomlFmt.generate "config.toml" config.settings;
    };
  };
}
