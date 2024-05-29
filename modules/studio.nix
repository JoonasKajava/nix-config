{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.mystuff.studio;
in {
  options.mystuff.studio = {
    enable = mkEnableOption "Studio applications";

    audio = {
      enable = mkDefault true;
    };

    image = {
      enable = mkDefault true;
    };

    video = {
      enable = mkDefault true;
    };
  };

  config = {
    environment.systemPackages = with pkgs;
      mkIf cfg.audio [
        audacity
      ]
      ++ mkIf cfg.image [
        gimp-with-plugins
      ]
      ++ mkIf cfg.video [
        davinci-resolve
      ];
  };
}
