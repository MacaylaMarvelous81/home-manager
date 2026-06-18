{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.usermod.vintagestory;
  vintagestory = pkgs.vintagestory.overrideAttrs (
    finalAttrs: prevAttrs: {
      # Applies to both vintagestory and vintagestory-server. I don't
      # necessarily want to set these for vintagestory-server, but I also want
      # to avoid wrapping a wrapper.
      makeWrapperArgs = [
        "--suffix"
        "__NV_PRIME_RENDER_OFFLOAD=1"
        "--suffix"
        "__NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0"
        "--suffix"
        "__GLX_VENDOR_LIBRARY_NAME=nvidia"
        "--suffix"
        "__VK_LAYER_NV_optimus=NVIDIA_only"
      ]
      ++ prevAttrs.makeWrapperArgs;
      # postInstallHooks = [
      #   ''
      #     wrapProgram $out/bin/vintagestory \
      #       --suffix __NV_PRIME_RENDER_OFFLOAD=1 \
      #       --suffix __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0 \
      #       --suffix __GLX_VENDOR_LIBRARY_NAME=nvidia \
      #       --suffix __VK_LAYER_NV_optimus=NVIDIA_only
      #   ''
      # ]
      # ++ (prevAttrs.postInstallHooks or [ ]);
    }
  );
in
{
  options.usermod.vintagestory = {
    enable = lib.mkEnableOption "Vintage Story game";
  };

  config = lib.mkIf cfg.enable {
    usermod.unfree.pkgnames = [ "vintagestory" ];

    home.packages = [ vintagestory ];

    home.sessionVariables.VINTAGE_STORY = "${vintagestory}/share/vintagestory";
  };
}
