{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.apps.firefox;
in {
  options.${namespace}.apps.firefox = {
    enable = mkEnableOption "Whether to install the Firefox browser";
    enablePWA = mkEnableOption "Whether to enable Firefox PWA support";
  };

  config = mkIf cfg.enable {
    home.packages = mkIf cfg.enablePWA (with pkgs; [
      firefoxpwa
    ]);

    programs.firefox = {
      enable = true;
      nativeMessagingHosts = mkIf cfg.enablePWA [pkgs.firefoxpwa];
      languagePacks = ["fi" "en"];
    };
  };
}
