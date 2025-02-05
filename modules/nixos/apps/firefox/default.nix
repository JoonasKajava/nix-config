{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) types mkEnableOption mkIf;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.apps.firefox;
in {
  options.${namespace}.apps.firefox = {
    enable = mkEnableOption "Whether to install the Firefox browser";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      firefoxpwa
    ];
    programs.firefox = {
      enable = true;
      package = pkgs.firefox;
      nativeMessagingHosts.packages = [pkgs.firefoxpwa];
    };
  };
}
