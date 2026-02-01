{ pkgs, lib, wlib, ... }:
{
  imports = [ wlib.modules.default ];

  config = {
    package = lib.mkDefault pkgs.jetbrains.rider;
    extraPackages = with pkgs; [ dotnet-sdk_10 dotnet-runtime_10 dotnet-aspnetcore_10 ];
  };
}
