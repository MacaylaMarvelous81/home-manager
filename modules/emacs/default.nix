{
  config,
  pkgs,
  lib,
  sources,
  ...
}:
let
  cfg = config.usermod.emacs;
  # toInit is taken from nix-doom-emacs-unstraightened flake.nix, which is under the following license
  #
  # Copyright 2024 Google LLC
  #
  # Licensed under the Apache License, Version 2.0 (the "License");
  # you may not use this file except in compliance with the License.
  # You may obtain a copy of the License at
  toInit =
    lib:
    let
      inherit (lib)
        concatLines
        concatStringsSep
        isList
        mapAttrsToList
        toPretty
        ;
    in
    attrs:
    concatLines (
      [ "(doom!" ]
      ++ (mapAttrsToList (
        cat: modules:
        (concatLines (
          [ (":" + cat) ]
          ++
            (mapAttrsToList (
              mod: value:
              if value == true then
                mod
              else if isList value then
                "(${mod} ${concatStringsSep " " value})"
              else
                abort "${toPretty value} not supported"
            ))
              modules
        ))
      ) attrs)
      ++ [ ")" ]
    );
in
{
  options.usermod.emacs = {
    enable = lib.mkEnableOption "emacs config";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      (pkgs.callPackage (import sources.nix-doom-emacs-unstraightened) {
        inherit toInit;
        doomSource = sources.doomemacs;
        doomModules = sources.doomemacs-modules;

        doomDir = ./doom.d;
        doomLocalDir =
          if pkgs.stdenv.hostPlatform.isDarwin then
            "${config.home.homeDirectory}/Library/Application Support/nix-doom"
          else
            "${config.xdg.dataHome}/nix-doom";
      }).doomEmacs
    ];
  };
}
