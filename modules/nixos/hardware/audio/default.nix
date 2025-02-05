{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) types mkEnableOption mkIf optionals;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.hardware.audio;
in {
  options.${namespace}.hardware.audio = {
    enable = mkEnableOption "Audio functionality";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; (optionals (!config.${namespace}.hardware.video.terminalOnly) [
      qpwgraph
    ]);
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };
  };
}
